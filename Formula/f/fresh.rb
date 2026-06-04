class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "7255c8ae3a059abda15ad425ac8bfbd65c563a6379446ca1424f633bb5c14e20"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "671b97459be9225b067829a391cf9cf0bded2618f2f3b7545d58c52c78f661fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e837043ee9c2e6ec59cd46d959ce712c8286f66893d724cd8b41f03e72f31407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01563fb06121f9895d6cdf459737438c3e5943d18aca9b1e221225faa101c3d6"
    sha256 cellar: :any,                 arm64_linux:   "ca7206e74eed6133acc1da75a034ce34d21bd5d4fbcc373b82f2d6967f5cb15f"
    sha256 cellar: :any,                 x86_64_linux:  "8fc2e0f5595ba8104b4ba3199e5df008c5fe9f603c7f72895d1cb6f11e394240"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")

    env = [
      "HOME=#{testpath}",
      "XDG_CONFIG_HOME=#{testpath}/.config",
      "XDG_DATA_HOME=#{testpath}/.local/share",
      "XDG_STATE_HOME=#{testpath}/.local/state",
      "XDG_CACHE_HOME=#{testpath}/.cache",
    ].join(" ")

    paths = shell_output("#{env} #{bin}/fresh --no-upgrade-check --cmd config paths")
    assert_match "Fresh directories:", paths
    assert_match testpath.to_s, paths

    sessions = shell_output("#{env} #{bin}/fresh --no-upgrade-check --cmd session list")
    assert_match "No active sessions.", sessions
  end
end
