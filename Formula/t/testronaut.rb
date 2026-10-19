class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.1.tgz"
  sha256 "2a3f9d2d0d37cd1c9a88b67a301dac7d8fbaffa3086ab676a275c5f02eca993a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aad4868b98a240d8e8fb7cd506eba13084cc77e499c50379366a4b24e1e1cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aad4868b98a240d8e8fb7cd506eba13084cc77e499c50379366a4b24e1e1cfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c52e6a3caa4a10c6be9a8fa7a1c118b8a1fea0945ef5175768b3b2f246e83925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c52e6a3caa4a10c6be9a8fa7a1c118b8a1fea0945ef5175768b3b2f246e83925"
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
