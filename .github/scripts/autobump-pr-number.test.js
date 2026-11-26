const assert = require('node:assert/strict')
const { execFileSync } = require('node:child_process')
const path = require('node:path')
const test = require('node:test')

const filter = path.join(__dirname, 'autobump-pr-number.jq')
const findPR = (formula, prs) => execFileSync('jq', ['-r', '--arg', 'formula', formula, '-f', filter], {
  input: JSON.stringify(prs), encoding: 'utf8',
}).trim()

const sibling = { number: 14876, title: 'plannotator-tui 0.11.7', headRefName: 'bump-plannotator-tui-0.11.7' }
const exact = { number: 14822, title: 'plannotator 0.29.4', headRefName: 'bump-plannotator-0.29.4' }

test('another formula with the same branch prefix does not suppress the bump', () => {
  assert.equal(findPR('plannotator', [sibling]), '')
})

test('finds the exact bump after a sibling or non-bump PR', () => {
  const maintenance = { number: 14821, title: 'plannotator livecheck update', headRefName: 'fix-plannotator' }
  assert.equal(findPR('plannotator', [sibling, maintenance, exact]), String(exact.number))
})
