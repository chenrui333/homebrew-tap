class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.3.6.tgz"
  sha256 "28b30283dd51fb3a143ae77e73a3300e10d12ea77e9e7c8ed37f6801b2bc29f9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a3d3b5dc3b5e988e48ae2fdf705ac6779424317739261bddfd2b215069b3221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a3d3b5dc3b5e988e48ae2fdf705ac6779424317739261bddfd2b215069b3221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a3d3b5dc3b5e988e48ae2fdf705ac6779424317739261bddfd2b215069b3221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cedaa35eee698dd6d15e86f35bb5e51beae1ac99c207a173e4638e94fd1f4a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cedaa35eee698dd6d15e86f35bb5e51beae1ac99c207a173e4638e94fd1f4a9d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "Missions directory not found: missions", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end
