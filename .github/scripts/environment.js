/**
 * Environment configuration script for GitHub Actions CI
 * 
 * This script reads PR labels and sets outputs for the build workflow:
 * - syntax-only: Skip expensive build steps for syntax-only or published-bottle CI
 * - linux-runner: Ubuntu runner for x86_64 Linux builds
 * - linux-arm64-runner: Ubuntu runner for ARM64 Linux builds
 * - fail-fast: Whether to stop on first failing matrix build
 * - timeout-minutes: Timeout for build jobs
 * - container: Container configuration for Linux builds
 * - build-matrix: JSON matrix for formula build jobs
 * - test-bot-formulae-args: Arguments for brew test-bot
 */
const PUBLISHED_LABEL = 'CI-published-bottle-commits'
const PUBLISHED_HEAD_CONTEXT = 'homebrew-tap/published-bottle-head'
// `brew pr-upload` commits bottles as BrewTestBot (git-user-config) with `brew bottle --merge`'s subject.
const BOTTLE_COMMIT_EMAIL = '1589480+BrewTestBot@users.noreply.github.com'
const BOTTLE_COMMIT_MESSAGE = /^[^\s:]+: (?:add|update) \S+ bottle\.$/

module.exports = async ({github, context, core}, formula_detect, {
    sleep = ms => new Promise(resolve => setTimeout(resolve, ms)),
    publication_wait_ms = 3 * 60 * 1000,
    publication_poll_ms = 10 * 1000
} = {}) => {
    const fs = require('fs')
    const path = require('path')
    const is_pull_request = context.eventName === 'pull_request'
    const pull_request = context.payload?.pull_request
    const labels = is_pull_request ? (pull_request?.labels ?? (await github.rest.pulls.get({
        owner: context.repo.owner,
        repo: context.repo.repo,
        pull_number: context.issue.number
    })).data.labels) : []
    const label_names = labels.map(label => label.name)
    const autobump_branch = pull_request?.head?.repo?.full_name === `${context.repo.owner}/${context.repo.repo}` &&
        pull_request.head.ref?.startsWith('bump-')
    const current_head = pull_request?.head?.sha

    async function head_has_published_status() {
        const statuses = await github.paginate(github.rest.repos.listCommitStatusesForRef, {
            owner: context.repo.owner,
            repo: context.repo.repo,
            ref: current_head,
            per_page: 100
        })
        // Statuses are newest first; only the latest bot-authored status for the context counts.
        const marker = statuses.find(status =>
            status.context === PUBLISHED_HEAD_CONTEXT &&
            status.creator?.login === 'github-actions[bot]')
        return marker?.state === 'success'
    }

    async function head_is_bottle_commit() {
        const {data: commit} = await github.rest.git.getCommit({
            owner: context.repo.owner,
            repo: context.repo.repo,
            commit_sha: current_head
        })
        return BOTTLE_COMMIT_MESSAGE.test(commit.message?.trimEnd() ?? '') &&
            commit.author?.email === BOTTLE_COMMIT_EMAIL &&
            commit.committer?.email === BOTTLE_COMMIT_EMAIL
    }

    // publish.yml pushes the bottle commit before it labels the PR and records the head status,
    // so the push's own run waits briefly for both instead of rebuilding a published head.
    async function wait_for_bottle_publication() {
        const attempts = Math.ceil(publication_wait_ms / publication_poll_ms)
        for (let attempt = 1; attempt <= attempts; attempt++) {
            console.log(`Waiting for bottle publication on ${current_head} (attempt ${attempt}/${attempts}).`)
            await sleep(publication_poll_ms)
            const {data: refreshed} = await github.rest.pulls.get({
                owner: context.repo.owner,
                repo: context.repo.repo,
                pull_number: context.issue.number
            })
            if (refreshed.head?.sha !== current_head) {
                console.log('Pull request head changed while waiting for bottle publication.')
                return false
            }
            if (refreshed.labels.some(label => label.name === PUBLISHED_LABEL) && await head_has_published_status()) {
                return true
            }
        }
        console.log('Bottle publication was not recorded in time. Running tests job.')
        return false
    }
    const linux_runner = 'ubuntu-24.04'
    const linux_arm64_runner = 'ubuntu-24.04-arm'
    const container = {
        // Keep the generated matrix on Homebrew's main tag so formula CI follows
        // current test-bot behavior; Renovate does not update JS-embedded digests.
        image: 'ghcr.io/homebrew/ubuntu24.04:main',
        options: '--user=linuxbrew -e GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED'
    }

    const macos_matrix = [
        {runner: 'macos-26', cleanup: true},
        {runner: 'macos-15', cleanup: true}
    ]
    const linux_matrix = [
        {
            runner: linux_runner,
            container,
            workdir: '/github/home',
            cleanup: false,
            timeout: 4320
        },
        {
            runner: linux_arm64_runner,
            container,
            workdir: '/github/home',
            cleanup: false,
            timeout: 4320
        }
    ]

    async function changed_formula_files() {
        if (!is_pull_request) {
            return []
        }

        const files = await github.paginate(github.rest.pulls.listFiles, {
            owner: context.repo.owner,
            repo: context.repo.repo,
            pull_number: context.issue.number,
            per_page: 100
        })
        return files
            .map(file => file.filename)
            .filter(filename => /^Formula\/.*\.rb$/.test(filename))
    }

    async function detect_platform_scope_from_formulae() {
        const formula_files = await changed_formula_files()
        if (formula_files.length === 0) {
            return 'unknown'
        }

        const workspace = process.env.GITHUB_WORKSPACE || process.cwd()
        const scopes = new Set()

        for (const formula_file of formula_files) {
            const formula_path = path.join(workspace, formula_file)
            if (!fs.existsSync(formula_path)) {
                return 'unknown'
            }

            const content = fs.readFileSync(formula_path, 'utf8')
            const linux_only_formula = /^\s*depends_on\s+:linux\b/m.test(content)
            const macos_only_formula = /^\s*depends_on\s+:macos\b/m.test(content)
            if (linux_only_formula) {
                scopes.add('linux')
            }
            if (macos_only_formula) {
                scopes.add('macos')
            }
            if (!linux_only_formula && !macos_only_formula) {
                scopes.add('all')
            }
        }

        return scopes.size === 1 ? [...scopes][0] : 'all'
    }

    async function detect_platform_scope() {
        const linux_only = label_names.includes('linux-only')
        const macos_only = label_names.includes('macos-only')
        const formula_scope = await detect_platform_scope_from_formulae()

        if (formula_scope !== 'unknown') {
            return formula_scope
        }

        if (linux_only && !macos_only) {
            return 'linux'
        }
        if (macos_only && !linux_only) {
            return 'macos'
        }
        if (linux_only && macos_only) {
            return 'all'
        }

        return detect_platform_scope_from_formulae()
    }

    function build_matrix_for_scope(scope) {
        switch (scope) {
        case 'linux':
            return linux_matrix
        case 'macos':
            return macos_matrix
        default:
            return macos_matrix.concat(linux_matrix)
        }
    }
    
    // Check for labels that intentionally skip expensive formula builds.
    const merge_group_without_formulae = context.eventName === 'merge_group' &&
        ![formula_detect?.testing_formulae, formula_detect?.added_formulae, formula_detect?.deleted_formulae]
            .some(Boolean)
    const pull_request_without_formulae = is_pull_request &&
        ![formula_detect?.testing_formulae, formula_detect?.added_formulae, formula_detect?.deleted_formulae]
            .some(Boolean)
    const syntax_only = label_names.includes('CI-syntax-only') || merge_group_without_formulae || pull_request_without_formulae
    let published_bottle_commits = false
    if (is_pull_request && current_head && !syntax_only) {
        published_bottle_commits = (label_names.includes(PUBLISHED_LABEL) && await head_has_published_status()) ||
            (await head_is_bottle_commit() && await wait_for_bottle_publication())
    }
    if (syntax_only || published_bottle_commits) {
        const reason = merge_group_without_formulae
            ? 'merge_group with no detected formulae'
            : pull_request_without_formulae ? 'pull_request with no detected formulae'
            : syntax_only ? 'CI-syntax-only' : 'CI-published-bottle-commits'
        console.log(`${reason} label found. Skipping tests job.`)
        core.setOutput('syntax-only', 'true')
    } else {
        console.log('No build-skipping label found. Running tests job.')
        core.setOutput('syntax-only', 'false')
    }

    // Configure Linux runners
    core.setOutput('linux-runner', linux_runner)
    core.setOutput('linux-arm64-runner', linux_arm64_runner)

    // Configure fail-fast behavior
    if (label_names.includes('CI-no-fail-fast')) {
        console.log('CI-no-fail-fast label found. Continuing tests despite failing matrix builds.')
        core.setOutput('fail-fast', 'false')
    } else if (autobump_branch) {
        console.log('Formula autobump PR detected. Continuing tests despite failing matrix builds.')
        core.setOutput('fail-fast', 'false')
    } else {
        console.log('No CI-no-fail-fast label found. Stopping tests on first failing matrix build.')
        core.setOutput('fail-fast', 'true')
    }
    
    // Configure timeout
    if (label_names.includes('CI-long-timeout')) {
        console.log('CI-long-timeout label found. Setting long GitHub Actions timeout.')
        core.setOutput('timeout-minutes', '4320')
    } else {
        console.log('No CI-long-timeout label found. Setting standard GitHub Actions timeout.')
        core.setOutput('timeout-minutes', '240')
    }
    
    // Configure Linux container
    core.setOutput('container', JSON.stringify(container))

    // Configure build matrix
    const platform_scope = await detect_platform_scope()
    console.log(`Formula build matrix platform scope: ${platform_scope}`)
    core.setOutput('build-matrix', JSON.stringify(build_matrix_for_scope(platform_scope)))

    // Build test-bot arguments
    const test_bot_formulae_args = ["--only-formulae", "--junit", "--only-json-tab"]
    test_bot_formulae_args.push('--root-url="https://ghcr.io/v2/chenrui333/tap"')
    
    if (formula_detect && formula_detect.testing_formulae) {
        test_bot_formulae_args.push(`--testing-formulae=${formula_detect.testing_formulae}`)
    }
    if (formula_detect && formula_detect.added_formulae) {
        test_bot_formulae_args.push(`--added-formulae=${formula_detect.added_formulae}`)
    }
    if (formula_detect && formula_detect.deleted_formulae) {
        test_bot_formulae_args.push(`--deleted-formulae=${formula_detect.deleted_formulae}`)
    }
    
    // Handle additional test-bot flags based on labels
    if (label_names.includes('CI-test-bot-fail-fast')) {
        console.log('CI-test-bot-fail-fast label found. Passing --fail-fast to brew test-bot.')
        test_bot_formulae_args.push('--fail-fast')
    } else {
        console.log('No CI-test-bot-fail-fast label found. Not passing --fail-fast to brew test-bot.')
    }
    
    if (label_names.includes('CI-skip-livecheck')) {
        console.log('CI-skip-livecheck label found. Passing --skip-livecheck to brew test-bot.')
        test_bot_formulae_args.push('--skip-livecheck')
    } else {
        console.log('No CI-skip-livecheck label found. Not passing --skip-livecheck to brew test-bot.')
    }
    
    if (label_names.includes('CI-skip-revision-audit')) {
        console.log('CI-skip-revision-audit label found. Passing --skip-revision-audit to brew test-bot.')
        test_bot_formulae_args.push('--skip-revision-audit')
    } else {
        console.log('No CI-skip-revision-audit label found. Not passing --skip-revision-audit to brew test-bot.')
    }
    
    core.setOutput('test-bot-formulae-args', test_bot_formulae_args.join(" "))
}
