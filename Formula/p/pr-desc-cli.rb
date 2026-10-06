class PrDescCli < Formula
  desc "AI-powered PR description generator"
  homepage "https://github.com/chalet-dev/chalet"
  url "https://registry.npmjs.org/pr-desc-cli/-/pr-desc-cli-2.0.3.tgz"
  sha256 "59cb6fbe61187b100db447ebc550f933c527f543245aedbcbf8379b1ee4bce78"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9d3431afbae5f302285b96c97ea6e6921c01fef219b547b138ecb73f0c6d6f7b"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pr-desc --version")
    output = shell_output("#{bin}/pr-desc models")
    assert_match "llama-3.3-70b-versatile", output
  end
end
