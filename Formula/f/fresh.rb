class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "7255c8ae3a059abda15ad425ac8bfbd65c563a6379446ca1424f633bb5c14e20"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "801f0f82ac83870c286f786e97c4ae7ca0ac14c20980cfff4d53c96a37e5a186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "322dbc3230ebee5807cba55f34eb9fe5c9a7ad1bc2b077979eb56aeca25848a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7acedf88df0be2b0c34736eaeb213ff99b6c79fb40129e88d8005cc6d89c6cd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f377c940e946e9fc1d28bd1987391a77232e1105f6d605599a3892f86229bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ec31eea44ff9c35bd02162dc39d1f8061d44d278b4a025f57559fd203bd07ce"
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
