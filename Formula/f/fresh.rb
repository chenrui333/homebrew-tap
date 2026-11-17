class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "87cbbf4c0dd25ad1db7f59681319f324b3e1f6b472e41f6c04bab17ebe0ffda3"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fc72fc1c0004fa89773fdde625758c96bf9bfdf50d6e9b97940484b776d5d1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18f66dcef3ecef982a0550fb7f520fd67d4473bd42c7f33ef0a08de6ed429d3e"
    sha256 cellar: :any,                 arm64_linux:   "2af87d96716aa6b2342426b83bdfd1c6f5b98cc2797329fc34022356427c8c3c"
    sha256 cellar: :any,                 x86_64_linux:  "cfca0bf2685fd9addf1b0813468a6bdd06d7b435f7efc697656a700976e4cf98"
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
