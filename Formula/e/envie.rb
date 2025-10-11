class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.1.1.tgz"
  sha256 "2279c4b6fb0c6a7ab5c1fe825e8eee5e1942994de9f8f5344ed820c589cf1012"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "05f928cac1cb8613d458f40d6d2c103351565d83063958f03fca6f7eae048e17"
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
