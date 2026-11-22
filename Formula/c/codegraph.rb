class Codegraph < Formula
  desc "Local code intelligence and knowledge graph for AI coding agents"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://github.com/colbymchenry/codegraph/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "cb3de7b69eb6fad0562e29e5dbb132457d27349f3dfb7e715d01db28ecf834e2"
  license "MIT"
  head "https://github.com/colbymchenry/codegraph.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "f02b89dfb84378296093743822783b33fc5adb2c7589094fd75e40bffee1b874"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c23ab5efd29c107509c7c01bc70d1521fcc4715128b4518d0db640e8c58dc5e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7bb45fba416086f4056268ad62e0b03933e40469fe7501df8f49698d771dad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb57cdfb630604b8742ec121466b66ca5dc8a36905f9ce1fe7b0498bfca43387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72085b58b2e8c5eac96e04e7a4d28d48ed719a6b5c50ed9fadb3c223f870a314"
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
