class But < Formula
  desc "Standalone GitButler command-line Git client"
  homepage "https://docs.gitbutler.com/cli-overview"
  url "https://github.com/gitbutlerapp/gitbutler/archive/refs/tags/release/0.23.2.tar.gz"
  sha256 "dd4ff0e6bd6271f206e886f23ab85c5589347d0d4371835269322b8967fe3aaa"
  # Functional Source License 1.1 with a future MIT grant, not current MIT.
  license :cannot_represent
  head "https://github.com/gitbutlerapp/gitbutler.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0de0871877666bb228e12d42d8582758828a926d921c13d70c8f4a1b4dd0dee4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65a1a8b4e636eb9a2f55c30910f04b844c446ccbead2b269a64c140fa28a9465"
    sha256 cellar: :any,                 arm64_linux:   "2cd013d21c84627088d35628700552b0cd97b4ce1d36aca06d68387bc0ebb73a"
    sha256 cellar: :any,                 x86_64_linux:  "617c6d2b5b22010b728134f2d012956328c84a607291a8c3b0f8a82ffffd2008"
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
