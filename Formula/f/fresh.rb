class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "3ab409970e18e692ed7a046bc0c27f4a68119858928e4b4b499e992dc7a0a118"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae85d6ee20fc8bbe93ce54a2556c506edd1e6e96c11c6c6c43110461dd7bd64c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9949d1bc67938bc0b39c9a493a2d1d534282aa484c7e573a8009984893d67e10"
    sha256 cellar: :any,                 arm64_linux:   "8a6a554c630da92dc2627c6657becfbc969fdab208c97d1eed3fd0df02c7b368"
    sha256 cellar: :any,                 x86_64_linux:  "3d36173f5739170607854da317424498a6dc15b862f814565390919d26acac00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  on_linux do
    depends_on "llvm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
