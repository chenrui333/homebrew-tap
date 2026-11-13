class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.7.tgz"
  sha256 "257877551816c3f76c190b50a65a16f97178c25ccc5bbbf7590af3abb61bf3f5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86cdbe275c05e77d993ca7c7bc26538c1b40b219c049882d3cae57e6da26cb57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86cdbe275c05e77d993ca7c7bc26538c1b40b219c049882d3cae57e6da26cb57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d40c8f4948fbae144f52a1ae14bc1d877888c0c531dca470a56c844d082cd6a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40c8f4948fbae144f52a1ae14bc1d877888c0c531dca470a56c844d082cd6a2"
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
