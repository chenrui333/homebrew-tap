class PrDescCli < Formula
  desc "AI-powered PR description generator"
  homepage "https://github.com/chalet-dev/chalet"
  url "https://registry.npmjs.org/pr-desc-cli/-/pr-desc-cli-2.0.2.tgz"
  sha256 "a807d522b1d1106dafdda5f774309e5e4dafdda137715630af8f93843d10cb84"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9bc2eaecfe7a39bd33dfd5bfeb2cd8486e213eccde971e1695eadc6c1eb263"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85e8cdf125377730756da887d0ca9693350f94d8abe059fd3a78c1ecd025624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51493fd7063255db4c38a47b97be3456082c93721bf7cabbd0783fc8c09bd040"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pr-desc --version")
    output = shell_output("#{bin}/pr-desc models")
    assert_match "llama-3.3-70b-versatile", output
  end
end
