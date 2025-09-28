class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.0.12.tgz"
  sha256 "c8519a822f6a5709073d3e5e99a91106a97d1cc022191dbeb76cc854e9ecb865"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be9304d9585a0887738dbb74d1f88d3bfe0a2ebc045710a7d2deb95db329f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbb58a8f097905d768d75b6176688ef326483429d5702d5a9dfedcdaab47078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21dae632c995a90ee07d627625616c9bece77c69335e2d29814c01fd6ec94308"
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
