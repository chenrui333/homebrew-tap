class Codegraph < Formula
  desc "Local code intelligence and knowledge graph for AI coding agents"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://github.com/colbymchenry/codegraph/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "cb3de7b69eb6fad0562e29e5dbb132457d27349f3dfb7e715d01db28ecf834e2"
  license "MIT"
  head "https://github.com/colbymchenry/codegraph.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "eed436eba256216f439ac62a9a185bcd73f4ab8784b7d442c0cc63311ac38f80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "219eb9f36628a6b01ca4e9d7974f830602e9cc9a3b9b8310b82229c8a24fa340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0730d2d23907329446a60253f1a6c8f7b9985f0aa94fe0742f16d03202c074e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "183bf0c87041a8dfb79f13a26bd26f0d052dafe7128de5a18395fd1dd8b681fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aafc1f812d6c8e700bb4e04c7e86a47be1b3894df6b2bee7d794888488d29d9"
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
