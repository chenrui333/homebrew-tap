class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "24a59674b61cfc4bb8b95fb85725d9bd92ab8e4d7fc63f7566618e32dc5ea76a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d343bf7423d743f04303ac1503ca516402aaabbd9a59de5ecbbbd60b63e74f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec9d8a11406f9e28bb2bd191268f7fe230273308798db8ae2f57ed040184fd55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811a387448f1f2bf2d900b7d8da3ca3d48d7bb153bc4e241d8d4b36ebaf59270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9909b1f214a0c3194a859aa68d35bd1a0a6c1073a110ab265daf74cdf9a4650e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ccdcc6450adda48767fca54e0a08a37b424eb66df04d6e413fd72b80f973f3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ccboard")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccboard --version")

    claude_home = testpath/".claude"
    claude_home.mkpath
    ENV["CCBOARD_CLAUDE_HOME"] = claude_home

    output = shell_output("#{bin}/ccboard stats")
    assert_match "Sessions indexed:", output
  end
end
