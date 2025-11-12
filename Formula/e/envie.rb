class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.1.3.tgz"
  sha256 "3c062cfb3f4301f0560c819a226b0d908492108b1a5090ecbe3b7ea430c4c805"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "901a0729b76a20a6d582ffcad8b05e5f6b1175545bde39b19e0db45cd586bcd8"
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
