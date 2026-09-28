const assert = require('node:assert/strict')
const test = require('node:test')
const { classifyBumpFailure } = require('./autobump-formula-failure')

test('classifies a deleted upstream resource as a candidate skip', () => {
  assert.equal(classifyBumpFailure('Failed to download resource "cockroach"\ncurl: (56) The requested URL returned error: 404'), 'upstream-404')
})

test('classifies identical formula versions and URLs as manual-update skips', () => {
  assert.equal(classifyBumpFailure('You need to bump this formula manually since the new version and old version are both 1.10.22-r1.'), 'manual-update')
  assert.equal(classifyBumpFailure('You need to bump this formula manually since the new URL and old URL are both the same.'), 'manual-update')
})

test('classifies resource block failures as candidate skips', () => {
  assert.equal(classifyBumpFailure('Unable to update resource blocks for "specfact-cli" automatically.'), 'manual-resources')
})

test('identifies a concurrent push without overwriting the remote branch', () => {
  assert.equal(classifyBumpFailure('! [rejected] bump-bun-1.4.2 (non-fast-forward)'), 'branch-conflict')
})

test('keeps authentication, rate limit, and network failures run-fatal', () => {
  assert.equal(classifyBumpFailure('HTTP 403: API rate limit exceeded'), 'infrastructure')
  assert.equal(classifyBumpFailure('curl: (28) Operation timed out'), 'infrastructure')
  assert.equal(classifyBumpFailure('curl: (56) OpenSSL SSL_read: Connection reset by peer'), 'infrastructure')
})

test('retains unexpected candidate errors for the job summary', () => {
  assert.equal(classifyBumpFailure('Formula parser raised an unexpected exception'), 'candidate-error')
})
