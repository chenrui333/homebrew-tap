class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.8.tgz"
  sha256 "c8cdfb9e0a06244746f6ace4f927736624cd904e2cffa70ab10a2500fa6ac71b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e552dd18ef1e9b0069c836cde772070f5ae40f12fb4e7997f48d4278825616c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e552dd18ef1e9b0069c836cde772070f5ae40f12fb4e7997f48d4278825616c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b351e74f41ff67abc15ab097338a8672c8bad9eabca4a27e4c21ecd4f73b283b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b351e74f41ff67abc15ab097338a8672c8bad9eabca4a27e4c21ecd4f73b283b"
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
