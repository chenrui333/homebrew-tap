class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.17.tgz"
  sha256 "2a5711b59eb727adbab62102775b912a65a7fd5638ba4344fdc62b00f699cf42"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e41d24046bf48cf1daab809973a4664b43ceb90b2b417936323dc3fd4eb27d75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42ee1149073b8a9570ae0c6f34185fa6c585aa06f4ac1950fa45d58085ab959d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ee1149073b8a9570ae0c6f34185fa6c585aa06f4ac1950fa45d58085ab959d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f84e09c17bdd0e51521645ea59e33187b4bfb0e4c982a08cc97903412a6474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f84e09c17bdd0e51521645ea59e33187b4bfb0e4c982a08cc97903412a6474"
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
