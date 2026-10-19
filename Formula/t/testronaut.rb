class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.2.tgz"
  sha256 "c86a89d8c4d62b55372bb7edd20e9af6a9219e9ea5070772ec5babcbbdfccb8e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65fb21a5d04223d1b57cdc1819b3b9bc8acc7b6beb4a932385fe8b86f7860f01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65fb21a5d04223d1b57cdc1819b3b9bc8acc7b6beb4a932385fe8b86f7860f01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66de46163c96f937eea29e92d3fdb835c27ee382fd935422de9ea6d3b966a65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66de46163c96f937eea29e92d3fdb835c27ee382fd935422de9ea6d3b966a65c"
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
