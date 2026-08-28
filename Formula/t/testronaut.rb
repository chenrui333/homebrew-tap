class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.5.0.tgz"
  sha256 "1b2163dc7b0284a3d9c6024391db8a75c1b300ff8b944181d543925f8c734130"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47e47f042697400068788cdf9dc6158504692a20a078cc20ad1b0661a6a38869"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e47f042697400068788cdf9dc6158504692a20a078cc20ad1b0661a6a38869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47e47f042697400068788cdf9dc6158504692a20a078cc20ad1b0661a6a38869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbd9547cb6b3baf8b224294acbf2fc050afe3caba2fdf26eadae3dd52024f512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd9547cb6b3baf8b224294acbf2fc050afe3caba2fdf26eadae3dd52024f512"
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
