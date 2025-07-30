class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-11.0.9.tgz"
  sha256 "1ba31935d661e298791616c2dd921b8d460440c1c302ea81f99df9b6ddb1874c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9218317e561aba4d98c1d38523ddbca20ae6afaea7200f4b6080455c0d08c84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f50a5596701dd1f5b2082f40750e687777ad9d07dcba945ea02888b26cc30c05"
    sha256 cellar: :any_skip_relocation, ventura:       "7b5cee0b21cc4c69dba1f954327e24f896941b4d7bd67c6c0f7553c6778a8f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a8b29fc2071303792f1ac9c28233b5b881bf60911b434638769e126e130964"
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
