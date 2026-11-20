class But < Formula
  desc "Standalone GitButler command-line Git client"
  homepage "https://docs.gitbutler.com/cli-overview"
  url "https://github.com/gitbutlerapp/gitbutler/archive/refs/tags/release/0.23.5.tar.gz"
  sha256 "4eb588359948699057c80426840024c3e824c89a5d3136ecbb7f1af8f1c7818a"
  # Functional Source License 1.1 with a future MIT grant, not current MIT.
  license :cannot_represent
  head "https://github.com/gitbutlerapp/gitbutler.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6def28f8f4afedacc15e17f8c9709a55f36d694ffad72609d71e0b2169435c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1dec269c1c61a100a96517db3937b0ea76fd17dca0db5502da620ba4dd3e238"
    sha256 cellar: :any,                 arm64_linux:   "ca02e3d476314158ed5e5fc8cff18e5972bcec867053bf185c4e786522eee4b2"
    sha256 cellar: :any,                 x86_64_linux:  "a28ec381cf203025ad437412cf9511f8ec1ce5be9c5fe6770c401ad34e42dd58"
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
