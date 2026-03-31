class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.21.tar.gz"
  sha256 "578036ffc1dde76aa0bfd7f5f1ae675268f42e09aa7f4d2b824856e282bcc758"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3939e0bddb181ca9a9ac3b0146b0fbd7a570644c2d12ad40f9477a7662aec5ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1849bfbd5df52589d6d62cf9338626c0e0195e7d4aaff2e067220b0b120bd690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b708beb87af8ba0d31a6c814c98f31134381fda5619517b4bb509a4f18f50b30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20a2fab9289ed430115cccec7ede3cbdac015cfb9d3da3859b56f969387e8c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1133074358649eaee7082985dd0c2cb27c5cdb1f6f654f34e0c4c98f7fdfbb3c"
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
