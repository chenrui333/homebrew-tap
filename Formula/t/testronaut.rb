class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.13.tgz"
  sha256 "f788b7f5a50baaa1213db3189a7bfd71d221514dbee2c1e3638646252aab35aa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "108c52ed1dab4639e9c73f22efee1122075f34fe4e3999f39f8c7d98bbe7fbb1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82c28ab7bcb1be762c3cf267f088d691a0c18e4313947bf7fd44c323ba8fc51e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82c28ab7bcb1be762c3cf267f088d691a0c18e4313947bf7fd44c323ba8fc51e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e42542a1e395129b8662cd99a02a63ab2dc5d107b4a1761d3a60d070aeede1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e42542a1e395129b8662cd99a02a63ab2dc5d107b4a1761d3a60d070aeede1f8"
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
