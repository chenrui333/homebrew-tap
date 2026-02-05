class EasyLlmCli < Formula
  desc "Open-source AI agent that is compatible with multiple LLM models"
  homepage "https://github.com/ConardLi/easy-llm-cli"
  url "https://registry.npmjs.org/easy-llm-cli/-/easy-llm-cli-0.1.12.tgz"
  sha256 "0efb2e44ed9644570a290a107a87655d669824d458b26b0f5a3fbfea57317ef6"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "c8da67128eb77c7c9df5b3b9f981bc4cb0b95c16ee5ad97bb45225a32cad35e0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elc --version")
    assert_match "Data collection is disabled", shell_output("#{bin}/elc --list-extensions")
  end
end
