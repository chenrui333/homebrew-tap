class NightWatchCli < Formula
  desc "Async execution layer for PRDs and queued engineering work"
  homepage "https://github.com/jonit-dev/night-watch-cli"
  url "https://registry.npmjs.org/@jonit-dev/night-watch-cli/-/night-watch-cli-1.8.7.tgz"
  sha256 "7948b2d00f4b54fd15a641d35b8687666c0e9e81ec1ca03615ccb98fee6aa302"
  license "MIT"
  head "https://github.com/jonit-dev/night-watch-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "488e08552c757bc325cb2628056dbb5ae0163af2dc7045ddd9c17520c704d370"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "488e08552c757bc325cb2628056dbb5ae0163af2dc7045ddd9c17520c704d370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "488e08552c757bc325cb2628056dbb5ae0163af2dc7045ddd9c17520c704d370"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0871c99081e335fd4c9e255d91dfaf374727c557c76735f06f8bc2d588720a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0871c99081e335fd4c9e255d91dfaf374727c557c76735f06f8bc2d588720a6e"
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
