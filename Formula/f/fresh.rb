class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "b062b336a85bf290344fe4efb730468fd8bda6941e508bf76150a3afb6a9a2d6"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcf405b08479b1b01a5ca574b6672017496933249b10fd812987a4fda0e090e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51e48ec702cc4e31de75ae43be492bfd5d30fe4c74d1c7e8043fb29ea21e2f75"
    sha256 cellar: :any,                 arm64_linux:   "d6cd9646647599b6f7710043ccce09fe1ec816cd34aee5545154959dcc44b72a"
    sha256 cellar: :any,                 x86_64_linux:  "ec481b54394084edfb675b13a8b2a88640ca7112d33391a370cf596425445280"
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
