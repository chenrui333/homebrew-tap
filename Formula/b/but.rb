class But < Formula
  desc "Standalone GitButler command-line Git client"
  homepage "https://docs.gitbutler.com/cli-overview"
  url "https://github.com/gitbutlerapp/gitbutler/archive/refs/tags/release/0.23.4.tar.gz"
  sha256 "ae641f3f1479bad95a36ce8b773ed7fa1820be4d6e3d480960c233e4e1d79c34"
  # Functional Source License 1.1 with a future MIT grant, not current MIT.
  license :cannot_represent
  head "https://github.com/gitbutlerapp/gitbutler.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72b115e1fd86d6dfe772de8612e09cefa6bd66be7f19cf8a7d677184f7196607"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df54f76ae8d0018b2cbf7c70060853a2f8197aedd7165f7d9da24ee5f1782e9"
    sha256 cellar: :any,                 arm64_linux:   "a0f023aa499ee12479f4ed5c97e202a89738ebdf9984652b0d27a08cf52fc07d"
    sha256 cellar: :any,                 x86_64_linux:  "612ef2c12005d1a63c2182e512f0406450cb9642b03c93aafd7cb66b37410b0f"
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
