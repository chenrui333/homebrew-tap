class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.5.tgz"
  sha256 "f23a339b76fdab8e1c12917369a8dec73c47e912ca9df9e6ff57e26e53fc6b3a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3d55586d5d51b829ffcdd589d75061e7aafade0c2ffce4b6074a839dd5cb210"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d55586d5d51b829ffcdd589d75061e7aafade0c2ffce4b6074a839dd5cb210"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8db3a4e3714ab71031222f5f355edda4c007263ade9ed09359a73aeb2c4eaa7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db3a4e3714ab71031222f5f355edda4c007263ade9ed09359a73aeb2c4eaa7a"
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
