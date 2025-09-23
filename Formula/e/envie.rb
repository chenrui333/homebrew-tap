class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.0.9.tgz"
  sha256 "5ab20f4ca1716cdd9d4970a6bf8b3524449879cf7ecc6fe1587cc9f364ebaa3e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a87542dcdeee588882de3e34e066e2f3766bbb8b2d944ca64981d605ccf229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "048c84e1000577227cbe72fe78b94647d0bb023607926c840765b95755d92b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67a38576281ecda03177be3d7ad9d2068ac251ab7240385d7b054523fa00e906"
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
