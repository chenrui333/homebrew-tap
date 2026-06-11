class NightWatchCli < Formula
  desc "Async execution layer for PRDs and queued engineering work"
  homepage "https://github.com/jonit-dev/night-watch-cli"
  url "https://registry.npmjs.org/@jonit-dev/night-watch-cli/-/night-watch-cli-1.8.17.tgz"
  sha256 "25d3740d61c33c43448636ccf8ce8bd6561f756018cf7dfbd17b2bb33fc63268"
  license "MIT"
  head "https://github.com/jonit-dev/night-watch-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53770094a768796faced2e5442853fd98919f454d67d50358469c6cb05a67e03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53770094a768796faced2e5442853fd98919f454d67d50358469c6cb05a67e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53770094a768796faced2e5442853fd98919f454d67d50358469c6cb05a67e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccf59e143cfd33f918435cc3864b49fb3b32d2d4b932167c769b6ccfe7f76e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf59e143cfd33f918435cc3864b49fb3b32d2d4b932167c769b6ccfe7f76e54"
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
