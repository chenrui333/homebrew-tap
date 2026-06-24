class AmIVibing < Formula
  desc "Detect agentic coding environments and AI editors"
  homepage "https://github.com/ascorbic/am-i-vibing"
  url "https://registry.npmjs.org/am-i-vibing/-/am-i-vibing-0.5.0.tgz"
  sha256 "04355987537ac8578954e6f70a60c39b8d00bd151c0fdb90e2c7be50a311b7bc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "bd7f5d8e1cc6141562715eb3be877f0a9dbe811950c7bfe985cb337ebaee3e9b"
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
