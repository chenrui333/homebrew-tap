class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.11.0.tgz"
  sha256 "b586687698bf5deac317f9196038d4d5b58c6d24f68a9f095e2e58304c374283"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "957c6ce9082abb8c6debbb0f031ad8518bd00e39cc62dd6537243315bb28a128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "957c6ce9082abb8c6debbb0f031ad8518bd00e39cc62dd6537243315bb28a128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9538805eb8b8f500c9f9138cc6eed0ce24fd1826335c71b526ce4f224ed9a020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9538805eb8b8f500c9f9138cc6eed0ce24fd1826335c71b526ce4f224ed9a020"
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
