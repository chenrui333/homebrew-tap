class TerraCodeCli < Formula
  desc "AI-powered development companion with persistent memory and knowledge"
  homepage "https://github.com/TerraAGI/terra-code-cli"
  url "https://registry.npmjs.org/@terra-code/terra-code/-/terra-code-0.2.0.tgz"
  sha256 "4bf515dbcc31afacd00d7a0de5870246ae6c4301a73ba9c0c7d319412298ed6a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e481cdb9f1799321921f0a937091cfce5b86b26bc92ea244eb543e51d9d6b262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a6249d507d5740815dd036af7febfa47658489109ef0281de3f93fcd175a2e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75cf9f71eee1e5c710771d9913a55bee70dab176634325fbdc3d8f191819cb68"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args, "--ignore-scripts"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terra --version")
    assert_match "No MCP servers configured", shell_output("#{bin}/terra mcp list")
  end
end
