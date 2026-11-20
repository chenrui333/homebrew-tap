class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.10.tgz"
  sha256 "012f614b1bff53c8c63b317eaa6b4d991cd3f4e68aa0ab55efc297832ba993bd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3a35ead329dbae7a3be53551f43d869907a92d958fde5c11dd59ffa3a4a903b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a35ead329dbae7a3be53551f43d869907a92d958fde5c11dd59ffa3a4a903b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cbaab2eb0a2ef6bf6fd4963b4ca9ecd841bacd5d3254b7640ee98e18187a8e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cbaab2eb0a2ef6bf6fd4963b4ca9ecd841bacd5d3254b7640ee98e18187a8e7"
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
