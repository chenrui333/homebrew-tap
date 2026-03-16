class NightWatchCli < Formula
  desc "Async execution layer for PRDs and queued engineering work"
  homepage "https://github.com/jonit-dev/night-watch-cli"
  url "https://registry.npmjs.org/@jonit-dev/night-watch-cli/-/night-watch-cli-1.8.5.tgz"
  sha256 "508608afa8e3f44125a1b8fcdb41421412f17cc5bfd50ec46ad8022103d0e715"
  license "MIT"
  head "https://github.com/jonit-dev/night-watch-cli.git", branch: "main"

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  fails_with :clang do
    build 1699
    cause "better-sqlite3 fails to build"
  end

  def install
    ENV["npm_config_build_from_source"] = "true"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/night-watch --version")

    (testpath/"test-bin").mkpath
    (testpath/"test-bin/codex").write <<~SH
      #!/bin/sh
      echo "codex stub"
    SH
    chmod 0755, testpath/"test-bin/codex"

    system "git", "init", "-q"

    ENV.prepend_path "PATH", testpath/"test-bin"
    output = shell_output("#{bin}/night-watch run --dry-run --provider codex")
    assert_match "Dry Run: PRD Executor", output
    assert_match "Provider CLI", output
  end
end
