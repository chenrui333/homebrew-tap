class AmIVibing < Formula
  desc "Detect agentic coding environments and AI editors"
  homepage "https://github.com/ascorbic/am-i-vibing"
  url "https://registry.npmjs.org/am-i-vibing/-/am-i-vibing-0.4.0.tgz"
  sha256 "5e59f6fd20148e9753923d787b8dc9b6623a647fcb05cccb8c40af75cfd44f5a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "7f4e578d39f5dbd48f69a7ee3ab13dd9e88913a5cc7b88ce489110d37f56235c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/am-i-vibing 2>&1", 1)
    assert_match "✗ No agentic environment detected", output

    output = shell_output("#{bin}/am-i-vibing --format json 2>&1", 1)
    assert_equal false, JSON.parse(output)["isAgentic"]
  end
end
