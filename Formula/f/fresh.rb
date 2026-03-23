class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "ade96285323d42ae8a1df4ce6709757adb6c445248bafe3314971737a7252e62"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0e274699882ef948d5246e4ab7d9ad79080ce198781cd1b1b73162e5da24ab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f1be17ef04fc7b7c286526e50539f3be2605f033aa54815236ac1add9104c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1b8909181cc371c1c4fbb82d3e7c0ff007486bc80174183d2026693b0707624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8169458fb1466e8f6c6fbdc561f5f746cbc40ec6c559b0c14895c46198a8c95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db5c7152fffdc79403d30ee4a3978d5a5365d9ebc353e5b787dfff0f5f43773"
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
