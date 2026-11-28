class Codegraph < Formula
  desc "Local code intelligence and knowledge graph for AI coding agents"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://github.com/colbymchenry/codegraph/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "970c5106b48630d5250ffaebcf348350142ebd25074eb52b928e0c883c71187e"
  license "MIT"
  head "https://github.com/colbymchenry/codegraph.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "d4ab24d7ee2c8fba92e7f798f7e35b21302995c4a21b4616fd71a9ba424fdf70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "751a43b738c1b7d242f4de05806acd2518a021e7a5c106453410d85a6fc71e9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77291abab43b72b928017bfd56d461a8d6959a82a584b1b470107fee62638ad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bb8e626e580b56becbb99fc33ff7ce81065f02135ce76742ff9f4bc686210bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6616def51a82b5b79016dba6c93035553a562aaebebc59b6a3a9f3c2a8f1156"
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
