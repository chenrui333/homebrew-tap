class AmIVibing < Formula
  desc "Detect agentic coding environments and AI editors"
  homepage "https://github.com/ascorbic/am-i-vibing"
  url "https://registry.npmjs.org/am-i-vibing/-/am-i-vibing-0.3.0.tgz"
  sha256 "eb1072e7d0caa9dde999e67c60ea7ea5cd6b63308b947ac963252c7e597ff24d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "6ee65c011fa5d41de49e2bbc561074edf11fcdbcad0892f3ffd4c34e1a459274"
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
