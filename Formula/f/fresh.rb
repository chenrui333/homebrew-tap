class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "0e4b7ea378cd8665bf94d2da021eeb983f25af34971236e2ec7a97d3884fa8ac"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57514f32007b07bfb24924384472b7e8758342320ab365ba8fbe8672ddd5e345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32d8a88ddf342bc508bcea1520ce0caaf0a2cb618272f86a32945b8f63c3ef47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6152cfda521bda52cb5e442abad2ffa59459f133db3743f44446fc59e4cc51de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a26a32d7726b2677335d132753344e9960140df1745e6b623d0e756ab96c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "583c8f2e06c1a4879b9769e0bb2408620af090b91c0b5aeb8a5e62a480cbe5ba"
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
