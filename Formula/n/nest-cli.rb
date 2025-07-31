class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-11.0.10.tgz"
  sha256 "df35a72fc1e58679877feb45ecb6be0866ebbcd0c6bd5c46208985780705b2b2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a71cf6bf6c76684873c19e52314a5d30e3d891df17646441418b77e698579d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b327fdc2f41ca243a4239f760a7c672a8f1fac790f8f2413a7a45def12a64d87"
    sha256 cellar: :any_skip_relocation, ventura:       "924fbce4add47b4368349dec4c1b3650dfdeb7d3394a6a68a0279b9593ef8c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ac08bae75990b1de2db7738374fc1321c03694e8dce6527914a138f40049aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nest --version")

    output = shell_output("#{bin}/nest info")
    assert_match "System Information", output
  end
end
