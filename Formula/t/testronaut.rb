class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.12.1.tgz"
  sha256 "206413971fcd09560b364b8c537941d051c788277bd54b293a0847ef635842fb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c51d883964ed9c9f1bd97f0a9f688f0f1e184e5acdba0d9beaffedf5ae753fb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c51d883964ed9c9f1bd97f0a9f688f0f1e184e5acdba0d9beaffedf5ae753fb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb38c88db55bee2a9b3cec74c47b534930b14a7b7d3b995551b26d3c90be1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb38c88db55bee2a9b3cec74c47b534930b14a7b7d3b995551b26d3c90be1be"
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
