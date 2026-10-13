class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.12.2.tgz"
  sha256 "e2cbe2ddfb1f8505b68f72d6888e9edc82c5be96893c77890acfdb64ad04a703"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "198ebb5e3bd1f0bb0f00a9210084e02d22e330d2183d0d36e8aa320a44924be8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "198ebb5e3bd1f0bb0f00a9210084e02d22e330d2183d0d36e8aa320a44924be8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b04f76c5b0abab18bd04b9863bdf279b5f522853bf62028441d914743c0c3a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b04f76c5b0abab18bd04b9863bdf279b5f522853bf62028441d914743c0c3a48"
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
