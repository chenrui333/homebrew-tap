class Codegraph < Formula
  desc "Local code intelligence and knowledge graph for AI coding agents"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://github.com/colbymchenry/codegraph/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "10bbcceaba46be5d37324e94427684a6d33dcbb592c35fbe4d387c2a14a36ff9"
  license "MIT"
  head "https://github.com/colbymchenry/codegraph.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78414cab3dc3ed767247e9779e6beae008bf96387aafae95abfca3d284651dfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927b61d01dfae5c1f2f0f7b459b1cacaced3318c9e787f1a3e09336a67603928"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3230bbd85bf01a80529dbe32b4d28415f172a719d662babe25c618efd7707dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e37dbb8bc4beb8767691b09e580089edda6cc1f217659a5ed34265a5e95ba61"
  end

  # Upstream blocks Node >=25 because its tree-sitter WASM grammars can crash V8.
  depends_on "node@24"

  deny_network_access!

  def fetch
    args = std_npm_args(prefix: false)
    ENV.prepend_path "PATH", formula_opt_bin("node@24")
    system formula_opt_bin("node@24")/"npm", "ci", *args
    system formula_opt_bin("node@24")/"npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    args = std_npm_args(prefix: false)
    ENV.prepend_path "PATH", formula_opt_bin("node@24")
    npm = formula_opt_bin("node@24")/"npm"
    system npm, "ci", "--offline", *args

    # Nested npm scripts otherwise select the hoisted Vite 5 rather than UI's Vite 7.
    inreplace "ui/package.json", '"build": "vite build"',
                                 '"build": "node node_modules/vite/bin/vite.js build"'
    system npm, "run", "build"
    system npm, "install", "--offline", *std_npm_args
    ui_link = libexec/"lib/node_modules/@colbymchenry/codegraph/node_modules/@colbymchenry/codegraph-ui"
    rm ui_link if ui_link.symlink?

    (bin/"codegraph").write_env_script libexec/"bin/codegraph", PATH: "#{formula_opt_bin("node@24")}:$PATH"
  end

  test do
    ENV["CODEGRAPH_TELEMETRY"] = "0"
    assert_match version.to_s, shell_output("#{bin}/codegraph --version")

    project = testpath/"project"
    project.mkpath
    (project/"greeting.ts").write <<~TYPESCRIPT
      export function homebrewGreeting(name: string): string {
        return `Hello, ${name}!`;
      }
    TYPESCRIPT
    system bin/"codegraph", "init", project, "--yes"
    status = JSON.parse(shell_output("#{bin}/codegraph status #{project} --json"))
    assert_equal true, status.fetch("initialized")
    assert_equal 1, status.fetch("fileCount")
    results = JSON.parse(shell_output("#{bin}/codegraph query homebrewGreeting --path #{project} --json"))
    assert_equal "homebrewGreeting", results.first.fetch("node").fetch("name")
  end
end
