class NightWatchCli < Formula
  desc "Async execution layer for PRDs and queued engineering work"
  homepage "https://github.com/jonit-dev/night-watch-cli"
  url "https://registry.npmjs.org/@jonit-dev/night-watch-cli/-/night-watch-cli-1.8.24.tgz"
  sha256 "e4963f672164e06bb63de42debe9a149a771513964e6e815aa9b2b3f63837d5f"
  license "MIT"
  head "https://github.com/jonit-dev/night-watch-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ab3657535883ea813f9e0734d493cfa42fef5474502ce4c5aef9253be9c51d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ab3657535883ea813f9e0734d493cfa42fef5474502ce4c5aef9253be9c51d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab3657535883ea813f9e0734d493cfa42fef5474502ce4c5aef9253be9c51d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70ef58e74ad48bf4c86b0209bc73662cdbb70ede259a5f683ee7139634636440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70ef58e74ad48bf4c86b0209bc73662cdbb70ede259a5f683ee7139634636440"
  end

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
