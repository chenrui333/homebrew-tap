class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.0.3.tgz"
  sha256 "94b2cada4efcfca2ebed2b90ca8baa82b80d7bbaec34d766358805a0f970c141"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d4c32875a6967d826a202b5e69d84ccb1a2af13343469cf34bf6dd80d6117ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d4c32875a6967d826a202b5e69d84ccb1a2af13343469cf34bf6dd80d6117ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a83adf97b901fb1bad997aceddc5b8860b40a8b9940d2a4a8b59b70a3a41729a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a83adf97b901fb1bad997aceddc5b8860b40a8b9940d2a4a8b59b70a3a41729a"
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
