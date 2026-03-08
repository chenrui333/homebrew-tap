class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "6c42ea685f0b00130466ad97f352ae7360cb44b5c5ba9e853c4a157355029b44"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "400e41199bd5ba0678e602342027816f61c0723472976e533536173c5149eb7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8a05e7b033e939faa51b12e40ada6ec48a5325fa9d25b0657f93a0404d62bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd68ba8e09099012ea1846c78e53879f06ca3d8c9c77fa491380f8e58e6eb2a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8974a9af2837c05e48d8a9b80c4cec502c8d83a6a521e8c62cd208c6bdceb3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b37bd2decf6b7e9ae7fe8908d8c91322890369504247ab3b26e9c7c5b0f840"
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
