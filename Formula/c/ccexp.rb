class Ccexp < Formula
  desc "Exploring and managing Claude Code settings and slash commands"
  homepage "https://github.com/nyatinte/ccexp"
  url "https://registry.npmjs.org/ccexp/-/ccexp-4.0.0.tgz"
  sha256 "4050d11d372d06adeafe48da1ca7b2201b4e442fe4b8d6aa1943a17883e758c9"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccexp --version")
    output = shell_output("#{bin}/ccexp --path #{testpath}")
    assert_match "Create a CLAUDE.md file to get started", output
  end
end
