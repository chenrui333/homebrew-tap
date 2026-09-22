class Critique < Formula
  desc "Terminal UI for reviewing git changes"
  homepage "https://critique.work"
  url "https://github.com/remorses/critique/archive/refs/tags/critique@0.1.140.tar.gz"
  sha256 "f574ae6b1b34e8e45a3d4edf292f54cb0e12198e4e1b4e6cb880f4c3f27d0104"
  license "MIT"

  depends_on "bun"

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile"
  end

  def install
    cd "cli" do
      system "bun", "run", "build"
    end

    libexec.install "cli", "node_modules", "package.json", "bun.lock"
    (bin/"critique").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/cli/dist/cli.js" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/critique --version")

    system "git", "init", "--quiet", testpath
    output = shell_output("cd #{testpath} && #{bin}/critique web")
    assert_match "No changes to display", output
  end
end
