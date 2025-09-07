class ClaudeCmd < Formula
  desc "Claude Code Commands Manager"
  homepage "https://github.com/kiliczsh/claude-cmd"
  url "https://registry.npmjs.org/claude-cmd/-/claude-cmd-1.1.1.tgz"
  sha256 "c6b990f7c55ec1281dca603b284d55b468ca7bbdfe217fc8091f5a8f85f16367"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a85d3acc6ebd4e0b3c9525e2e6c0a34178254f49a5656013fb813fd92c135e62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d497c62e13ed0d32bda3e0e506fe5f696278f2aa3fdf60ad319f299a2bd20c61"
    sha256 cellar: :any_skip_relocation, ventura:       "2e8246741816ab61427fcdf9d836d6ad14dc5256e2431ebe80472b23ad20907c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0910801a8d5583c85a40a40fb278f5f0300fbda1a130dd9d749a40010c406155"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/claude-cmd list")
    assert_match "No commands installed yet", output
  end
end
