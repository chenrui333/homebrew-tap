class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.1.tgz"
  sha256 "2a3f9d2d0d37cd1c9a88b67a301dac7d8fbaffa3086ab676a275c5f02eca993a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f904f4d7147f7fbce57a2d2696b7e77e5c2a2ea90dbf098690468de708bc7d4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f904f4d7147f7fbce57a2d2696b7e77e5c2a2ea90dbf098690468de708bc7d4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8821fbdca3cf68810c3a2d2c227b3de9ada203d591c110fc76acca640f0e2f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8821fbdca3cf68810c3a2d2c227b3de9ada203d591c110fc76acca640f0e2f41"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "Missions directory not found: missions", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end
