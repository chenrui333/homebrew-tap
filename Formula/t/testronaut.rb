class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.12.2.tgz"
  sha256 "e2cbe2ddfb1f8505b68f72d6888e9edc82c5be96893c77890acfdb64ad04a703"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "567bb9ccb2d1f6a34f435b95fbf6303c6b45cf583a6cbbcec8770247080e0c05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "567bb9ccb2d1f6a34f435b95fbf6303c6b45cf583a6cbbcec8770247080e0c05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd7a2771ba6c39f40cc5900d036efb377f80905534428faa865d078b5205a1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd7a2771ba6c39f40cc5900d036efb377f80905534428faa865d078b5205a1d2"
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
