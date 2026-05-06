class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "9c493f2af15d2b87b672a67a3701b2e92a0835537fe171e3c0102224484d1d36"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bc05ececb31fdce75b14f158a1007c70ed1f3b4a5a571ed81a1fe5517522aa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0c44b64ea541a1c55b9704746bd06986df51e5f0b521f466a58facd866b3325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2b22aedc6eaec5a6de8286d87643027f1e5e2bf1e2cea74e8bc73a602930452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e1e032144ac2fba02d5f7ad29fc37c8b9217f44141372e65fbf6338c405590b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40c4d15c6490f64439e8b50b10b0fc0935ee1ceca6c11923a787e66beda8a908"
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
