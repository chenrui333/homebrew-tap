class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "d137a2db03a377c4f7af5c7cd29befff905d416f0240a5026b1ed3b20bdc49ce"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "632c569a8b47a5fbd02b8b940155ff083687fb125d02c04571930a2e71d460dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1724ab6f1770025b1156d25e6518ee50f4495b2bcbae0e5b5a52b339508d66a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a55875c1fa701f5da5248986d5af76038ede8c3b853063be96ddf942a9e4a45a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aabb2a742cdb3a804391fba4edd6b50f9d7d4ecb503cce9f30730be1beeeba67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1edeeddff108b711fe7c1bf98a6584b992e609cd470116d025a70ceaa50d5204"
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
