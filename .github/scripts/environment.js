/**
 * Environment configuration script for GitHub Actions CI
 * 
 * This script reads PR labels and sets outputs for the build workflow:
 * - syntax-only: Skip expensive build steps if CI-syntax-only label is present
 * - linux-runner: Ubuntu runner for x86_64 Linux builds
 * - linux-arm64-runner: Ubuntu runner for ARM64 Linux builds
 * - fail-fast: Whether to stop on first failing matrix build
 * - timeout-minutes: Timeout for build jobs
 * - container: Container configuration for Linux builds
 * - build-matrix: JSON matrix for formula build jobs
 * - test-bot-formulae-args: Arguments for brew test-bot
 */
module.exports = async ({github, context, core}, formula_detect) => {
    const fs = require('fs')
    const path = require('path')
    const is_pull_request = context.eventName === 'pull_request'
    const labels = is_pull_request ? (await github.rest.pulls.get({
        owner: context.repo.owner,
        repo: context.repo.repo,
        pull_number: context.issue.number
    })).data.labels : []
    const label_names = labels.map(label => label.name)
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
        {runner: 'macos-15', cleanup: true},
        {runner: 'macos-14', cleanup: true},
        {runner: 'macos-15-intel', cleanup: true}
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
    
    // Check for syntax-only label
    if (label_names.includes('CI-syntax-only')) {
        console.log('CI-syntax-only label found. Skipping tests job.')
        core.setOutput('syntax-only', 'true')
    } else {
        console.log('No CI-syntax-only label found. Running tests job.')
        core.setOutput('syntax-only', 'false')
    }

    // Configure Linux runners
    core.setOutput('linux-runner', linux_runner)
    core.setOutput('linux-arm64-runner', linux_arm64_runner)

    // Configure fail-fast behavior
    if (label_names.includes('CI-no-fail-fast')) {
        console.log('CI-no-fail-fast label found. Continuing tests despite failing matrix builds.')
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
