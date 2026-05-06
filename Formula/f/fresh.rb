class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "9c493f2af15d2b87b672a67a3701b2e92a0835537fe171e3c0102224484d1d36"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35cbea1ee75d2d1bf2e3521ff10a44f94d360c0f0d9657fa36de5a5e39561236"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c7a9e5b498bfdf8ad00c03bc93ba0375ea07748614ebe1e427de5a157062bf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1704a66b016e214ff07e72aa6b6b344a0f80743874fd4ec678a478536968e141"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86feaab81964a04a9183a9b49a96a112b582aa12434775f500d6da0b6b04bc8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bc47e6b2d271447ec909739cdff428a5795de38a6f8c63df7c2fc35351021a3"
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
