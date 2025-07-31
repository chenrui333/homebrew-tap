class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-11.0.10.tgz"
  sha256 "df35a72fc1e58679877feb45ecb6be0866ebbcd0c6bd5c46208985780705b2b2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb2988167a1beba3477abb6033ce23318f1ca6ae01c952b9bdc426d0b575196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bf5608ba84f440895e35aeab1be567bde6673c8c25b0801f9613edea2d366e2"
    sha256 cellar: :any_skip_relocation, ventura:       "d7393d535c01f5075be996bc6638f3d0130d9627c055574f67ce0d204c9b1696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10a854e556295d4585a74732197ba2db4ddde6be03e6abf1fd36a3e828141189"
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
