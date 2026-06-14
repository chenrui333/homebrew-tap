class Agentgraphed < Formula
  desc "Local-first analytics dashboard for AI coding sessions"
  homepage "https://github.com/sudomichael/agentgraphed"
  url "https://registry.npmjs.org/agentgraphed/-/agentgraphed-0.5.9.tgz"
  sha256 "3daa77b649fb3d2592721a04c3422219effa50531e7d39c5108481afa130e059"
  license "MIT"

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
