class TerraCodeCli < Formula
  desc "AI-powered development companion with persistent memory and knowledge"
  homepage "https://github.com/TerraAGI/terra-code-cli"
  url "https://registry.npmjs.org/@terra-code/terra-code/-/terra-code-0.2.0.tgz"
  sha256 "4bf515dbcc31afacd00d7a0de5870246ae6c4301a73ba9c0c7d319412298ed6a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "6987e9bcc735c3dec8336c9f4e54761f53072c3fbb94a7969bc478ce68a7110c"
    sha256 cellar: :any,                 arm64_sonoma:  "044e781743eb87dae9e66a031cc8b575e8f9e51587ecf802a3265d681be27797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d34574db455e6674da8bac5745d3d188d3658d46a8d40b50bc8638c5a266902a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args, "--ignore-scripts"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terra --version")
    assert_match "No MCP servers configured", shell_output("#{bin}/terra mcp list")
  end
end
