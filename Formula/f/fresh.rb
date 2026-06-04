class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "d709a3538d098d90af754d26d7d797315b5b8b4fb820d4201686f993bc580830"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea0343f5319bf6b79b86faad340b535068d8d60f2a10412eb78d8b58e08da582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3419171d0c5f95420201302267567bfb7cb2e9f8fc852853415f0b1a3124f19e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec4e9e260ba9a6adb41c6fa8437ad04b9ce0e7fe29e3c134af7e32aadcd1aa17"
    sha256 cellar: :any,                 arm64_linux:   "6e1991fe2d36ed78ff2d7d46c9193995f239dea4fedfed41b71616e17f6c1546"
    sha256 cellar: :any,                 x86_64_linux:  "d5351408ffad572cd13192f676a969beac49ff5a3c1cc207bf17f66cbce2124c"
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
