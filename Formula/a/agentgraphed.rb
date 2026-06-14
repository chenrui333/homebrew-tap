class Agentgraphed < Formula
  desc "Local-first analytics dashboard for AI coding sessions"
  homepage "https://github.com/sudomichael/agentgraphed"
  url "https://registry.npmjs.org/agentgraphed/-/agentgraphed-0.5.9.tgz"
  sha256 "3daa77b649fb3d2592721a04c3422219effa50531e7d39c5108481afa130e059"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "ac21581c604cb7f176e487f77389c9c2d107dc63f7b493c8a8ef45b0063ce66c"
    sha256 cellar: :any, arm64_sequoia: "dea4292d571c076ab91ec6f1f392a3261faa2bafe34dab715567405e2c41329c"
    sha256 cellar: :any, arm64_sonoma:  "dea4292d571c076ab91ec6f1f392a3261faa2bafe34dab715567405e2c41329c"
    sha256 cellar: :any, arm64_linux:   "10bed4d0c39b209a2b289f50a7176f7069e17b9265280abd834db44acba0c48c"
    sha256 cellar: :any, x86_64_linux:  "38734120a80ec9cd0ec7f4dbb38d3cdf293bd0044d0460b85a1bc50ebdaca481"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentgraphed --version")
    assert_match "agentgraphed", shell_output("#{bin}/agentgraphed --help")
  end
end
