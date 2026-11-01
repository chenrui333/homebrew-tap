class But < Formula
  desc "Standalone GitButler command-line Git client"
  homepage "https://docs.gitbutler.com/cli-overview"
  url "https://github.com/gitbutlerapp/gitbutler/archive/refs/tags/release/0.23.1.tar.gz"
  sha256 "6f1df8504e151f4b42042ab391fb62a4172fec9bbc68591e02ff49a6d1d9e77a"
  # Functional Source License 1.1 with a future MIT grant, not current MIT.
  license :cannot_represent
  head "https://github.com/gitbutlerapp/gitbutler.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5176bbcd46b1a24897c10bcd8374476c7d50ec4fc1d1d3ec6fa0933e882a01f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68dfa538885a8eef6ddf79583b9b1e690fa04a2c4b999979b7270dc820121309"
    sha256 cellar: :any,                 arm64_linux:   "4a58db3bbb91fa1e150b9fdc46b45fa717496081711c1ffc208a4788e8180b09"
    sha256 cellar: :any,                 x86_64_linux:  "e844a9d14576206d017a174319773581b2b79da6e969aa867edf0fbda0336898"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["VERSION"] = version.to_s
    ENV["CHANNEL"] = "release"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["ZSTD_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args(path: "crates/but"), "--features", "packaged-but-distribution"
    generate_completions_from_executable(bin/"but", "completions")
    pkgshare.install "LICENSE.md"
  end

  def caveats
    <<~EOS
      This installs only the source-built standalone CLI, not GitButler.app.
      The gitbutler cask also links a command called `but`; unlink that command
      before linking this formula if the desktop application is installed.
      GitButler is licensed under FSL-1.1-MIT; see #{pkgshare}/LICENSE.md.
    EOS
  end

  test do
    ENV["NO_BG_TASKS"] = "1"
    assert_match version.to_s, shell_output("#{bin}/but --version")
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "Homebrew Test"
    system "git", "config", "user.email", "test@example.com"
    (testpath/"fixture.txt").write "initial\n"
    system "git", "add", "fixture.txt"
    system "git", "commit", "-m", "Homebrew fixture"
    (testpath/"untracked.txt").write "local change\n"
    assert_match "untracked.txt", shell_output("#{bin}/but status --json")
  end
end
