class PrDescCli < Formula
  desc "AI-powered PR description generator"
  homepage "https://github.com/chalet-dev/chalet"
  url "https://registry.npmjs.org/pr-desc-cli/-/pr-desc-cli-2.0.3.tgz"
  sha256 "59cb6fbe61187b100db447ebc550f933c527f543245aedbcbf8379b1ee4bce78"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35c21837954cd721dd3a54ec9ef496b76fd863f2b5e58ce412c7108128eca340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ee603fd7ba4a9cb53f47fef74864356242370c18539c5dfe35623931920c2cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9c9c7371bfbca0b1cff29c6c9fffef20c7575a7ad4cdea6547f9d5c2b4bbaeb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pr-desc --version")
    output = shell_output("#{bin}/pr-desc models")
    assert_match "llama-3.3-70b-versatile", output
  end
end
