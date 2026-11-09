const SIDECARS = new Set([".typos.toml", "audit_exceptions/signing_audit_skiplist.json"])
const SHA = /^[a-f0-9]{40}$/i
const CASK = /^Casks\/.+\.rb$/
const TOKEN = /^[a-z0-9][a-z0-9+@._-]*$/

function reject(reason) {
  return { eligible: false, reason }
}

function tokenFor(path) {
  if (!CASK.test(path) || path.split("/").some(part => !part || part === "." || part === "..")) return null
  const token = path.slice(path.lastIndexOf("/") + 1, -3)
  return TOKEN.test(token) ? token : null
}

function declaration(source) {
  const match = /^cask "([^"\r\n]+)" do\r?$/m.exec(source)
  return match && { token: match[1], start: match.index + 'cask "'.length }
}

function registry(source) {
  const value = JSON.parse(source)
  if (!value || Array.isArray(value) || typeof value !== "object" ||
      Object.values(value).some(target => typeof target !== "string")) {
    throw new Error("Cask routing registry must be a flat string map")
  }
  // JSON.parse otherwise silently accepts an overwritten duplicate key.
  const strings = [...source.matchAll(/"(?:\\[\s\S]|[^"\\])*"/g)]
  const keys = strings.filter((_, index) => index % 2 === 0).map(match => JSON.parse(match[0]))
  if (new Set(keys).size !== keys.length) throw new Error("Duplicate cask routing key")
  return value
}

function oneNewRoute(base, head, oldToken, target) {
  return !Object.hasOwn(base, oldToken) && Object.hasOwn(head, oldToken) && head[oldToken] === target &&
    Object.keys(head).length === Object.keys(base).length + 1 &&
    Object.keys(base).every(key => Object.hasOwn(head, key) && head[key] === base[key])
}

// Read data only: privileged consumers must never evaluate a PR's Ruby or JavaScript.
async function validateCaskChange({ github, owner, repo, pr, files }) {
  if (!Array.isArray(files) || files.some(file => !file || typeof file.filename !== "string" || !file.filename ||
      typeof file.status !== "string" || (file.previous_filename !== undefined && typeof file.previous_filename !== "string")) ||
      new Set(files.map(file => file.filename)).size !== files.length) {
    return reject("Malformed changed-file records")
  }
  const casks = files.filter(file => CASK.test(file.filename) || CASK.test(file.previous_filename || ""))
  if (casks.length === 0) return { eligible: true, kind: "none" }
  if (casks.length !== 1) return reject("Exactly one logical cask is required")
  const cask = casks[0]
  const token = tokenFor(cask.filename)
  if (!token) return reject("Invalid cask path or token")

  let kind, oldToken, oldPath, routePath
  if (["added", "modified"].includes(cask.status) && cask.previous_filename === undefined) {
    if (!files.every(file => file === cask || (SIDECARS.has(file.filename) &&
        ["added", "modified", "removed"].includes(file.status) && file.previous_filename === undefined))) {
      return reject("Cask updates allow only supported maintenance sidecars")
    }
    kind = "update"
  } else if (cask.status === "renamed") {
    oldPath = cask.previous_filename
    oldToken = typeof oldPath === "string" && tokenFor(oldPath)
    if (!oldToken || oldToken === token) return reject("A cask rename must change its token")
    kind = "rename"
    routePath = "cask_renames.json"
  } else if (cask.status === "removed" && cask.previous_filename === undefined) {
    kind = "migration"
    oldPath = cask.filename
    oldToken = token
    routePath = "tap_migrations.json"
  } else {
    return reject("Unsupported cask change status")
  }

  const route = routePath && files.find(file => file.filename === routePath)
  if (routePath && (files.length !== 2 || !route || !["added", "modified"].includes(route.status) ||
      route.previous_filename !== undefined)) {
    return reject("A cask route requires only its cask and routing registry")
  }
  if (kind === "update") return { eligible: true, kind, token }
  if (!SHA.test(pr?.head?.sha || "") || (routePath && !SHA.test(pr?.base?.sha || ""))) {
    return reject("Immutable PR revisions are required")
  }

  try {
    const trees = new Map()
    const treeAt = async ref => {
      if (!trees.has(ref)) {
        trees.set(ref, github.rest.git.getTree({ owner, repo, tree_sha: ref }).then(({ data }) => {
          if (!data || !Array.isArray(data.tree) || data.truncated !== false) throw new Error("Incomplete Git tree")
          return data.tree
        }))
      }
      return trees.get(ref)
    }
    const currentFormulaExists = async () => {
      const root = await treeAt(pr.base.sha)
      for (const directory of ["Formula", "Aliases"]) {
        const matches = root.filter(entry => entry.path === directory)
        if (!matches.length) continue
        if (matches.length !== 1 || matches[0].type !== "tree" || matches[0].mode !== "040000" ||
            !SHA.test(matches[0].sha || "")) throw new Error(`Invalid ${directory} Git tree`)
        let entries
        if (directory === "Formula") {
          const { data } = await github.rest.git.getTree({
            owner, repo, tree_sha: matches[0].sha, recursive: "1",
          })
          if (!data || data.truncated !== false || !Array.isArray(data.tree)) {
            throw new Error("Incomplete formula Git tree")
          }
          entries = data.tree
        } else {
          entries = await treeAt(matches[0].sha)
        }
        if (entries.some(entry => typeof entry.path !== "string")) throw new Error(`Invalid ${directory} Git entry`)
        if (entries.some(entry => directory === "Formula"
          ? entry.path.split("/").at(-1) === `${oldToken}.rb`
          : entry.path === oldToken)) return true
      }
      return false
    }
    const regularBlob = async (path, ref) => {
      let tree = ref
      const parts = path.split("/")
      for (let index = 0; index < parts.length; index++) {
        const entries = await treeAt(tree)
        const matches = entries.filter(entry => entry.path === parts[index])
        if (matches.length !== 1 || !SHA.test(matches[0].sha || "")) throw new Error(`Missing Git entry for ${path}`)
        const entry = matches[0]
        if (index === parts.length - 1) {
          if (entry.type !== "blob" || !["100644", "100755"].includes(entry.mode)) {
            throw new Error(`Not a regular file: ${path}`)
          }
          return entry.sha
        }
        if (entry.type !== "tree" || entry.mode !== "040000") throw new Error(`Not a directory: ${path}`)
        tree = entry.sha
      }
    }
    const sourceAt = async (path, ref) => {
      let data
      try {
        const response = await github.rest.repos.getContent({ owner, repo, path, ref })
        data = response.data
      } catch (error) {
        if (error.status === 404) error.caskPolicyMissingContent = true
        throw error
      }
      if (!data || data.type !== "file" || data.path !== path || data.encoding !== "base64" ||
          typeof data.content !== "string" || data.target !== undefined || data.submodule_git_url) {
        throw new Error(`Invalid file payload for ${path}`)
      }
      const encoded = data.content.replace(/[\r\n]/g, "")
      const bytes = Buffer.from(encoded, "base64")
      const source = bytes.toString("utf8")
      if (bytes.toString("base64") !== encoded || !Number.isSafeInteger(data.size) || data.size !== bytes.length ||
          !Buffer.from(source, "utf8").equals(bytes)) {
        throw new Error(`Invalid base64 or UTF-8 payload for ${path}`)
      }
      if (data.sha !== await regularBlob(path, ref)) throw new Error(`Mismatched Git blob for ${path}`)
      return source
    }
    const registryMissingAt = async (ref, error) => {
      if (route.status !== "added" || error.status !== 404 || error.caskPolicyMissingContent !== true) return false
      return !(await treeAt(ref)).some(entry => entry.path === routePath)
    }

    const { data: comparison } = await github.rest.repos.compareCommitsWithBasehead({
      owner, repo, basehead: `${pr.base.sha}...${pr.head.sha}`,
    })
    const base = comparison?.merge_base_commit?.sha
    if (!SHA.test(base || "")) return reject("Missing immutable merge base")
    if (kind === "migration" && await currentFormulaExists()) {
      return reject("Cask migration would redirect an existing formula or formula alias")
    }
    const baseSource = await sourceAt(oldPath, base)
    const header = declaration(baseSource)
    if (!header || header.token !== oldToken) return reject("Base cask declaration does not match its token")
    if (kind === "rename") {
      const headSource = await sourceAt(cask.filename, pr.head.sha)
      const renamed = baseSource.slice(0, header.start) + token + baseSource.slice(header.start + oldToken.length)
      if (headSource !== renamed) return reject("A rename may change only the cask declaration token")
    }

    let baseRegistry
    try {
      baseRegistry = registry(await sourceAt(routePath, base))
      if (route.status === "added") return reject("An added routing registry already exists at the merge base")
    } catch (error) {
      // A new registry requires absence in both Contents and the immutable Git tree.
      if (!await registryMissingAt(base, error)) throw error
      baseRegistry = {}
    }
    const headRegistry = registry(await sourceAt(routePath, pr.head.sha))
    if (!oneNewRoute(baseRegistry, headRegistry, oldToken, kind === "rename" ? token : "homebrew/cask")) {
      return reject("Routing registry must preserve every entry and add exactly the requested cask route")
    }
    // Do not overwrite a route established on main while this head's checks ran.
    let currentRegistry = baseRegistry
    if (pr.base.sha !== base) {
      try {
        currentRegistry = registry(await sourceAt(routePath, pr.base.sha))
      } catch (error) {
        if (!await registryMissingAt(pr.base.sha, error)) throw error
        currentRegistry = {}
      }
    }
    if (Object.hasOwn(currentRegistry, oldToken)) return reject("Cask route already exists on the current base")
    return { eligible: true, kind, token, oldToken, oldPath, newPath: kind === "rename" ? cask.filename : null, baseSource }
  } catch (error) {
    return reject(`Cannot validate cask data: ${error?.message || String(error)}`)
  }
}

module.exports = { validateCaskChange }
