class NightWatchCli < Formula
  desc "Async execution layer for PRDs and queued engineering work"
  homepage "https://github.com/jonit-dev/night-watch-cli"
  url "https://registry.npmjs.org/@jonit-dev/night-watch-cli/-/night-watch-cli-1.8.11.tgz"
  sha256 "d74e91a8f46c222a6946015bcc5fb79177668e21f6c7b2b9069cfdb1d07233ac"
  license "MIT"
  head "https://github.com/jonit-dev/night-watch-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45e31ba25e3fb9ec280dffaf55c92600662ea66994778820621831a953f19952"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45e31ba25e3fb9ec280dffaf55c92600662ea66994778820621831a953f19952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e31ba25e3fb9ec280dffaf55c92600662ea66994778820621831a953f19952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1021d6770ade2910f2342f78fde76c29dd5bf6adf04682dda20065ad1102ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1021d6770ade2910f2342f78fde76c29dd5bf6adf04682dda20065ad1102ba7"
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
