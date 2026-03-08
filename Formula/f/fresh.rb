class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "6c42ea685f0b00130466ad97f352ae7360cb44b5c5ba9e853c4a157355029b44"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

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
