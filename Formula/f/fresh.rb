class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "38d06554b8c825750c34ba273824590dfcb23861921b55dbd509b6efca81896e"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "019a449cd036a648ee18b2a2ca92ba166540849e5d88a7a367d148867846c44f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2d2f5024c17c66925498227bcc0f1a56b289273d19f935cbd0c6ecfedb239a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e945b1c8fcb7b6c5a865bbda3e1ad5fe4906e09df311d5bdb33cde46f051136a"
    sha256 cellar: :any,                 arm64_linux:   "0b086ed80b2010859f79fc0d933a447d99e61964f56415d647f6b141aa3e0a32"
    sha256 cellar: :any,                 x86_64_linux:  "263e308704cf72cc314a0bfed384493b187fa46f94ccd0a24c9546eddfcd65d1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")

    env = [
      "XDG_CONFIG_HOME=#{testpath}/.config",
      "XDG_DATA_HOME=#{testpath}/.local/share",
      "XDG_STATE_HOME=#{testpath}/.local/state",
      "XDG_CACHE_HOME=#{testpath}/.cache",
    ].join(" ")

    paths = shell_output("#{env} #{bin}/fresh --no-upgrade-check --cmd config paths")
    assert_match "Fresh directories:", paths
    assert_match testpath.to_s, paths

    sessions = shell_output("#{env} #{bin}/fresh --no-upgrade-check --cmd session list")
    assert_match "No running daemons.", sessions
  end
end
