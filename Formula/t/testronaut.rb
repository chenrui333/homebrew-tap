class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.3.5.tgz"
  sha256 "a57465eccedabcfa23a2c681b027451c2e0b658885bb544ad9d8330dbe0cfa54"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d3847da49034e7f840ef3db93e8fadd5c8d0d9299351fa7eee8bee432718fc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d3847da49034e7f840ef3db93e8fadd5c8d0d9299351fa7eee8bee432718fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d3847da49034e7f840ef3db93e8fadd5c8d0d9299351fa7eee8bee432718fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62064c67153bdb8e20330198eab9e44c2d6d668499b1e9d93a995d403201ae93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62064c67153bdb8e20330198eab9e44c2d6d668499b1e9d93a995d403201ae93"
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
