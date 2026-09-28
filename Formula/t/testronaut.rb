class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.9.4.tgz"
  sha256 "673005367d82194b87810a58b996a0c546f4bab9e193bb5014de7c7d679a92f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1313a9677dc1aa6424224bc9f23356693e1885099f8d09d4ccd350cce1a6a4ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1313a9677dc1aa6424224bc9f23356693e1885099f8d09d4ccd350cce1a6a4ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d838ad0c5fadcb0ff66f1b8776b9616213d2a8367ac023822eb12be0bad55e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d838ad0c5fadcb0ff66f1b8776b9616213d2a8367ac023822eb12be0bad55e2"
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
