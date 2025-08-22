class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.8.tgz"
  sha256 "4c6bd7322cc9d757682ace232d38dd9782bbc17c0c2731f48b587a19c4a1566b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "021af971ac5278f054e25c7bdfb692bc5c9ae8428a7320309d60e5972cb39735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b91e9a963dd3949c630bb6b45ebe2a46d48b4521c200279a27fdaf3a347feacd"
    sha256 cellar: :any_skip_relocation, ventura:       "abfc8d6aa16a74b9e545f94040494c109f041409cbbded661bd46fd3ca5923a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cb46045bddea016dc8e3465007ea128b7f1d0ad005b2ac0b60c57f1c7b33a1a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
