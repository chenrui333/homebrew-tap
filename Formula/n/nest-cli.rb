class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-11.0.6.tgz"
  sha256 "7272a1c25651dc0e593767cae6717a87ef7c8253c214ac7e05a1a2a52a92c266"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e01a3452485ceba99f7cf6bce3e793a94172ee217d97114a0a7ff2fa6ab2c910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eaf4a0827fcbe2329b7691d77ad1b883fd818f8211080804f31edabadd534a1"
    sha256 cellar: :any_skip_relocation, ventura:       "8588f5a115f41cc8e0c866733ed5d86f7d9fa451a14563559f23aedc644a2050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91f9e57c8b25d4330f0e8b93d71efab6a7620e6bff749302b89e895b62e5a66d"
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
