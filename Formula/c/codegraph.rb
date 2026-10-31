class Codegraph < Formula
  desc "Local code intelligence and knowledge graph for AI coding agents"
  homepage "https://github.com/colbymchenry/codegraph"
  url "https://github.com/colbymchenry/codegraph/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "10bbcceaba46be5d37324e94427684a6d33dcbb592c35fbe4d387c2a14a36ff9"
  license "MIT"
  head "https://github.com/colbymchenry/codegraph.git", branch: "main"

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
