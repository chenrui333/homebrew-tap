class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.24.tar.gz"
  sha256 "8f9d55b275305a19f4a9e8c7fc90331491c443ed45fd4d7f59d05523b571bdb5"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5863e718b6cb189658f3df62e64209b5d99c247690f2a27494aad7af3ba91e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48e3d3df21b10ae76497b5b94388f69bfbb9e46ae9031bf04b2c58e2b0a4a80b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff20908469b934f661f5d6aecb5f6d7a3a6b1493228d13030f93125b489664fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ca8f6bf882caede6bcc91b8b77c5389697f9d41d840a52fb7d0df7054a649f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb8a7455ed9bbac6fee19f99bb1b82f2d1580775f0430b0bff8816d5967993a4"
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
