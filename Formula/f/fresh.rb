class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "1e4592e19cf7a95df5901e21d350f88534caf7fec9348801b76eabbf8d8d9c1d"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfe352bd5bcf1a60737566eef4e10ef5ccca50c96a360227a001574a8595a9ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41d1ffc2aa4454783e20203d16754c81e0b34a5619b124329cb5a99a63b1c2d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d39176014331f479216eacd9d992348c2962b00f824fad6eb1f63a3849997207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37bf1d269e337fe51599091edb3fe4f6f127830328e89a99de4ccdd4dff2df0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d34f89c43fe3b7fcdf9f5fa701b0525cbec709798ba39d02badb7650a9a5fe3c"
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
