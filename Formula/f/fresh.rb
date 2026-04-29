class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f8a3946662accf1989eabc4204333ff47e80214db3c2bf95fad45feae9c197f8"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdb69178645a9525ebed2a7b5c66fff0e814ca2febc775fdeac30902608674f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8098fbecf9f057c5f33d8ad18e9623edc050ec8324cc008905d21d2af878de5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3473b0b7483ea199f37e220b8b07576c9247c138f3b5dfd49e1f53c8f19d9d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f80b6908744940c2883decbb1a4493bb95a3ad767c4b89bce8c11fee0210824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f33621bfb648c735f4d67691a52191525aa34dcb6dc2e6a87816ea503e064a"
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
