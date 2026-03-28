class NightWatchCli < Formula
  desc "Async execution layer for PRDs and queued engineering work"
  homepage "https://github.com/jonit-dev/night-watch-cli"
  url "https://registry.npmjs.org/@jonit-dev/night-watch-cli/-/night-watch-cli-1.8.9.tgz"
  sha256 "ee7276e9f4817d697aaa9cb635a3098dc5fa4c40ab4278eb495d2f3040f8af4f"
  license "MIT"
  head "https://github.com/jonit-dev/night-watch-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b2becbbb766344ebae4e654b1c5e77d195e32fac7c60da0cbbc3521768cc75c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b2becbbb766344ebae4e654b1c5e77d195e32fac7c60da0cbbc3521768cc75c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b2becbbb766344ebae4e654b1c5e77d195e32fac7c60da0cbbc3521768cc75c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec6057115517342acd4631633ef2c077dc65ebb9a30fbf42cc593073c770a5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6057115517342acd4631633ef2c077dc65ebb9a30fbf42cc593073c770a5ba"
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
