class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "52fe3372310ef37e9ceb495d1b5b8d8401765fdda6e0c656f832316baae0c8b5"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7ccfd67562cf2b192370066978c0f02a3e2faa7333758fb59024649a95063ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf32506371983c01dea2a819c08ff32470a00bc3697a0081a78aa62710aba25d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84151fbff17e002465f1a4c8b11f8f9ae359980ef67edea07676fe480ef0068c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05a092a15abf4f5c04e834bd8a2d3327483b2b186ff2f7eb9eef81f7f037d88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d554faa75e3b104cb10b0e5dfc4d371c6953920a78d2b5858d992cba3e56de24"
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
