const fs = require('node:fs')

function classifyBumpFailure(output) {
  if (/non-fast-forward|fetch first/i.test(output)) return 'branch-conflict'
  if (/You need to bump this formula manually/i.test(output)) return 'manual-update'
  if (/Failed to download resource/i.test(output) && /(?:returned error: 404|HTTP 404)/i.test(output)) {
    return 'upstream-404'
  }
  if (/Unable to update resource blocks .* automatically/i.test(output)) return 'manual-resources'
  const infrastructureFailure = [
    /API rate limit exceeded/i,
    /HTTP (?:401|403|408|429|5\d\d)/i,
    /returned error: (?:401|403|408|429|5\d\d)/i,
    /curl: \(\d+\)/i,
    /could not resolve|timed? out|connection (?:refused|reset)|network is unreachable/i,
    /authentication failed|permission denied|could not read from remote repository/i,
    /brew: command not found|invalid username or password/i,
    /write access to repository not granted|resource not accessible by integration/i,
    /remote rejected|GH006/i,
  ].some((pattern) => pattern.test(output))
  if (infrastructureFailure) {
    return 'infrastructure'
  }

  return 'candidate-error'
}

if (require.main === module) {
  const logPath = process.argv[2]
  if (!logPath) {
    console.error('Usage: autobump-formula-failure.js <log-file>')
    process.exit(2)
  }
  process.stdout.write(`${classifyBumpFailure(fs.readFileSync(logPath, 'utf8'))}\n`)
}

module.exports = { classifyBumpFailure }
