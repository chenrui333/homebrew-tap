class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "b048bfa38b9b50a262f19ac49d254a1479926ddb74d496367649892ac8720495"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6af55d65aad3c947ebe5ab5e5ca5e117d4863ed145d607e51887381b3747db09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6940e3b6d0185b3b08cb1426c56e0a742b519744be9f94f4283fa2973c46f67"
    sha256 cellar: :any,                 arm64_linux:   "44fa39cd8c3e54faf357bf2f4af4d4585c9b62a9610ad8a0cc87cc3fcd93b7ae"
    sha256 cellar: :any,                 x86_64_linux:  "6b32d80a6334f591c9eecd99607ca5dcc7bbf160ac472fa27fe0ad51550f533f"
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
