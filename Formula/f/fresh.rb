class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "38d06554b8c825750c34ba273824590dfcb23861921b55dbd509b6efca81896e"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88a1abacbc3a91c8f5b463ad278117ba779a1ba5ed0e6c5d6ce236990628c029"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fabf038b74cc034f07d32cb1bc055adafeb98659314b8fc440ab23e9eacdea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3408ba32915f853012b8b33371001b92ed884cf295326d62c3ad04f287278b7d"
    sha256 cellar: :any,                 arm64_linux:   "764cbad2b35094430649066e524cdb7825475bea744d8f57c807c74c891b06bf"
    sha256 cellar: :any,                 x86_64_linux:  "8e5120ba727be6803a98b85ef20d4ee44a92e4e6afeaceb435fad93db9cdb0f9"
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
