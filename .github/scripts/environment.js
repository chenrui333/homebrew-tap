/**
 * Environment configuration script for GitHub Actions CI
 * 
 * This script reads PR labels and sets outputs for the build workflow:
 * - syntax-only: Skip expensive build steps if CI-syntax-only label is present
 * - linux-only: Skip macOS runners if linux-only label is present
 * - macos-only: Skip Linux runners if macos-only label is present
 * - linux-runner: Ubuntu runner for x86_64 Linux builds
 * - linux-arm64-runner: Ubuntu runner for ARM64 Linux builds
 * - fail-fast: Whether to stop on first failing matrix build
 * - timeout-minutes: Timeout for build jobs
 * - container: Container configuration for Linux builds
 * - test-bot-formulae-args: Arguments for brew test-bot
 */
module.exports = async ({github, context, core}, formula_detect) => {
    const { data: { labels: labels } } = await github.rest.pulls.get({
        owner: context.repo.owner,
        repo: context.repo.repo,
        pull_number: context.issue.number
    })
    const label_names = labels.map(label => label.name)
    
    // Check for syntax-only label
    if (label_names.includes('CI-syntax-only')) {
        console.log('CI-syntax-only label found. Skipping tests job.')
        core.setOutput('syntax-only', 'true')
    } else {
        console.log('No CI-syntax-only label found. Running tests job.')
        core.setOutput('syntax-only', 'false')
    }

    // Check for linux-only label
    if (label_names.includes('linux-only')) {
        console.log('linux-only label found. Skipping macOS runners.')
        core.setOutput('linux-only', 'true')
    } else {
        console.log('No linux-only label found. Running all platforms.')
        core.setOutput('linux-only', 'false')
    }

    // Check for macos-only label
    if (label_names.includes('macos-only')) {
        console.log('macos-only label found. Skipping Linux runners.')
        core.setOutput('macos-only', 'true')
    } else {
        console.log('No macos-only label found. Running all platforms.')
        core.setOutput('macos-only', 'false')
    }

    // Configure Linux runners
    core.setOutput('linux-runner', 'ubuntu-22.04')
    core.setOutput('linux-arm64-runner', 'ubuntu-22.04-arm')

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
    const container = {}
    container.image = 'ghcr.io/homebrew/ubuntu22.04:main'
    container.options = '--user=linuxbrew'
    core.setOutput('container', JSON.stringify(container))

    // Build test-bot arguments
    const test_bot_formulae_args = ["--only-formulae", "--junit", "--only-json-tab", "--skip-recursive-dependents"]
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
