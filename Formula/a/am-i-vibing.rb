class AmIVibing < Formula
  desc "Detect agentic coding environments and AI editors"
  homepage "https://github.com/ascorbic/am-i-vibing"
  url "https://registry.npmjs.org/am-i-vibing/-/am-i-vibing-0.1.0.tgz"
  sha256 "830ce89a5c6863cd8712f83b26b9924485789fdc3a8359a6ef2872cfe85981a7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3497cf97f7a47c23b3d0acc14ae6f6e70807379d7e18fe2fc72380da1f9ccf65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "213b42f1675d928b82ab1e24de6c3112593c82f43c59e4e9550ee8e27d0b71fa"
    sha256 cellar: :any_skip_relocation, ventura:       "dfdc204b7b8d30169aba1e1dbbaaaa1450c301cc95083fa7e8fac9a1bd910f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b05a78696c8a7db848c7571b0a57e6d8eac76be353a380ef6bab3da7f44d56c"
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
