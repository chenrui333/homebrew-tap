class NightWatchCli < Formula
  desc "Async execution layer for PRDs and queued engineering work"
  homepage "https://github.com/jonit-dev/night-watch-cli"
  url "https://registry.npmjs.org/@jonit-dev/night-watch-cli/-/night-watch-cli-1.8.9.tgz"
  sha256 "ee7276e9f4817d697aaa9cb635a3098dc5fa4c40ab4278eb495d2f3040f8af4f"
  license "MIT"
  head "https://github.com/jonit-dev/night-watch-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26519dbd3ba713fb09b8ec6cbfee6db56e7d9c0242ea3ef12664347372653f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26519dbd3ba713fb09b8ec6cbfee6db56e7d9c0242ea3ef12664347372653f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26519dbd3ba713fb09b8ec6cbfee6db56e7d9c0242ea3ef12664347372653f78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1e5f5fed8410cb886449c4d6793b70f44db5233387e97ce244cbe9be4712e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e5f5fed8410cb886449c4d6793b70f44db5233387e97ce244cbe9be4712e06"
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
