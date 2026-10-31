class Zaly < Formula
  desc "Hackable terminal coding agent"
  homepage "https://zaly.dev"
  url "https://github.com/folke/zaly/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "18f45e022f9861bce78f05db9804a3d22c52f2aa998b8d93917a3365cea297be"
  license "MIT"
  head "https://github.com/folke/zaly.git", branch: "main"

  depends_on "bun" => :build
  depends_on "node"

  deny_network_access!

  def fetch
    system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    bun = formula_opt_bin("bun")/"bun"
    # Keep pending Shiki work alive in one-shot CLI commands; completion already clears these timers.
    inreplace "packages/tui/src/shiki/client.ts", /^ +timeout\.unref\(\)\n/, ""
    system bun, "run", "build"
    system bun, "install", "--frozen-lockfile", "--production", "--ignore-scripts"

    # Preserve workspace-relative exports, worker entrypoints, themes, skills, and plugins.
    libexec.install "packages", "plugins", "node_modules", "package.json"
    (bin/"zaly").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/packages/cli/dist/zaly.mjs" "$@"
    SH
    chmod 0755, bin/"zaly"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zaly --version")
    config = shell_output("#{bin}/zaly --print-config --model homebrew/model --no-plugins")
    assert_match "homebrew/model", config
  end
end
