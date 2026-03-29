class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.20.tar.gz"
  sha256 "55ff033a3865e108a99a59eee6ea06428c4db3c8e19f1d9605e402c18015e6f5"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc6f2d761d1cca70e13379645317436716dc9292e1a12889b5465264293f3f1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff9d7b72a7e6cb97b0ca779d064ffbb8c782130776bdd877c70e1c92db8887a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9732c8e72f32616ff0cbf802be8a85f5c2bcd95a4f91f0e86f00a1827ed048c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "314566cb108fe55393b00f89c70847424139d0a16a50d3cc1684ec00af45c5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08754c9ddf2525524e50eb8ac867e3c53f67ff82e7289b82ffdbf6f4716db6c4"
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
