class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "a315a38f0598554998e7b256d4ef997d158592532d43ca52328c8dc8e177d65f"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b9bffe3891d9db13464861a53487527b2e79780dde295e02693ac77dcac5b00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e90a11a9df5461a04e617072c191be1e85ef425eb9ab1bfdf4cdc912252bc614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bab56515c6d5d7d27a9ec8c6f4ac8b670634ee7d84dc9da381cd845ba32aa677"
    sha256 cellar: :any,                 arm64_linux:   "4f8ae4b08fc3325ade7c2fbbd9cd14d4578b5ec72f51b18435ad9778496b2582"
    sha256 cellar: :any,                 x86_64_linux:  "b0461f68db21ba0e6b6e122bd9ce16e47231e936161d6e0c7ea75f2fa33e9aa6"
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
