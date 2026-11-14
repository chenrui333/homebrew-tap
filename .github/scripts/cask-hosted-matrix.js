const { isDeepStrictEqual } = require("node:util")

// Homebrew's xcode-27 fleet is not available to this tap. Keep the generator's
// requirement-filtered native hosted jobs; never pretend they cover macOS 27.
function hostedCaskMatrix(matrix) {
  if (!Array.isArray(matrix) || matrix.length === 0) throw new Error("Empty or invalid cask matrix")
  return matrix.flatMap(job => {
    if (!job.cask && /^tap_syntax(?: \(stable\))? \([^)]+\)$/.test(job.name)) {
      return [{ ...job, runner: "macos-26", name: job.name.replace(/\([^)]+\)$/, "(macos-26)") }]
    }
    if (job.runner !== "xcode-27") return [job]

    const architecture = /\(xcode-27, (arm|intel)\)$/.exec(job.name)?.[1]
    const equivalent = architecture && matrix.some(candidate => {
      const hostedArchitecture = /\(macos-(?:15|26), (arm|intel)\)$/.exec(candidate.name)?.[1]
      return ["macos-15", "macos-26"].includes(candidate.runner) &&
        hostedArchitecture === architecture && candidate.tap === job.tap &&
        candidate.cask?.token === job.cask?.token && candidate.cask?.path === job.cask?.path &&
        job.cask?.token && job.cask?.path &&
        candidate.skip_install === job.skip_install && candidate.skip_audit === job.skip_audit &&
        isDeepStrictEqual(candidate.audit_args, job.audit_args) &&
        isDeepStrictEqual(candidate.fetch_args, job.fetch_args)
    })
    if (!equivalent) {
      throw new Error(`Unsupported cask runner requirement: ${job.name}; no equivalent requirement-compatible hosted macOS/architecture verification`)
    }
    return []
  })
}

module.exports = { hostedCaskMatrix }
