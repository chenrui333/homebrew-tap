class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "b062b336a85bf290344fe4efb730468fd8bda6941e508bf76150a3afb6a9a2d6"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f36e8d79d94e702ff20557fadf2172faaee693e5dd7192c87e43d7e25c33f247"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d190a1262bd9d5f44cc3518aa146cdde14ba04d31a4be01ee6867c708daa8c7"
    sha256 cellar: :any,                 arm64_linux:   "528797a02a5ccdafd3c970db35d73d960eabfe4c12ad64a890a379e35cce25de"
    sha256 cellar: :any,                 x86_64_linux:  "f9c266e3e1f0ab24db69c2789176599aa380ec0492c851e45560ec1fbae46786"
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
