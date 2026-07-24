class Fresh < Formula
  desc "Modern terminal-based text editor with plugin support"
  homepage "https://getfresh.dev/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "050993b6f91aeced80e73d71a03f84c855a64664bb65bec4a1ded043a7a794e4"
  license "GPL-2.0-only"
  head "https://github.com/sinelaw/fresh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4a7755fc44dddf730de0c33f3e6fd5d8a1341e612f2f7615c2478d52bb561df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e89e8f5d2d15430d80c670d50eb23d3e576055e15d6fa0af306df87206d6220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda16405c31d1b86c9d10eca29b01bf19b4f15e2e13b442fd58c1bb13c97ece0"
    sha256 cellar: :any,                 arm64_linux:   "ba61836812ad44525ab28859a0fa0c6943b5430025daff8b5e742bbad2820df7"
    sha256 cellar: :any,                 x86_64_linux:  "cbcd26c94e61868e12a40f7ead31e1d94bf52d54ba74c4efb186b5dc31e0c07d"
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
