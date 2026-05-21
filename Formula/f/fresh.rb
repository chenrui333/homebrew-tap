class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "7c52ec24536b3703b3db9d201601c2ee807156a3f68713b790bb6f55290d2811"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b855d9cef67f0928f3b249135d2fbcd92ba968643b55026db109e8ef25bb707"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d17120b6d43ca43eda18342e60f8bbf89fcc0ca42aeffcbb001aaef569ba124c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c1d5877702f04a9508fda87024ac53ed8a802c8b4e0ff8114443d4ac57ec3e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "813736739bac0c5107554d37c1e86c5e760d9ca6cd0883ff8543ca9916dd592d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ca2040a0eb298954616ac05f02a8637d65a21c90d671f2a928002a85fcc1462"
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
