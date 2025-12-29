class EasyLlmCli < Formula
  desc "Open-source AI agent that is compatible with multiple LLM models"
  homepage "https://github.com/ConardLi/easy-llm-cli"
  url "https://registry.npmjs.org/easy-llm-cli/-/easy-llm-cli-0.1.11.tgz"
  sha256 "f8f2adf430a2034e8991017538ef77d618d1af5a025ada3139787f24d6a27d83"
  license "Apache-2.0"

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
