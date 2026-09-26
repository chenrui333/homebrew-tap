class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.9.1.tgz"
  sha256 "e944ccd24ee0bfffa56f3da59c033bf5a2f6d2a2d603937fc02035aa81afdf82"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "460792361aa492c30f899409da5e8e75c9a9deb6906244517a3a421e6f7daca3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "460792361aa492c30f899409da5e8e75c9a9deb6906244517a3a421e6f7daca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4530a013a2948c6dbee79d62df601ec3f98309162183f7b1b8e76250eb184b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4530a013a2948c6dbee79d62df601ec3f98309162183f7b1b8e76250eb184b5a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
