class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.0.15.tgz"
  sha256 "cc10aa1a9892a757f608a01ac477831abda0829d6f5bf8adf05ec6ab4ea40786"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd85f784f792a7c899e72884329e70312ea7c7d75a948373075479ce2ff2c0e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b60324876c0208fc9ed17f7198760a83197b3844e424e22b4a8cd9fb93731181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2333eaa47ddf886801905cd0ebf041e8c73b057cd25dde29c10180c2521c0f7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Error: No authentication token found.", shell_output("#{bin}/envie environment list 2>&1", 1)
    output = shell_output("#{bin}/envie login 2>&1", 1)
    assert_match "Login failed: Please specify which keypair to use", output
  end
end
