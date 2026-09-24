class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "3472273fcf77b019922b32ddffad061cc068bfb260344865c239c8eb056d92bf"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98d2a13e5f1df0a6a6bf9578c5f1e5ade5c78431f7f95d17fb0f93d183512258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc5cd437c7eb16a065f4991166d4c6816b6b113a67f58d252b44188d0c3983d7"
    sha256 cellar: :any,                 arm64_linux:   "b2fa13301da07ee37042ce62967910c090b501e9bf5df489731a2018fbaa2f28"
    sha256 cellar: :any,                 x86_64_linux:  "e69b9b461b6f8b7abc378040911c3022b69b983378f02d646cbd69a5e867f2cd"
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
