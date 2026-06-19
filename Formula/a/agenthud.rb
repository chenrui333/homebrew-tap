class Agenthud < Formula
  desc "Claude Code TUI dashboard for parallel sessions and sub-agents"
  homepage "https://github.com/neochoon/agenthud"
  url "https://registry.npmjs.org/agenthud/-/agenthud-0.19.0.tgz"
  sha256 "b680199be1fc4c2fe6a602ce345d382887e2f8dfc5624314be16a543b9acf5e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "7dff8ce862ea158e53b0c6335374a95b83688a0e04d747d81d1f22ffb4412ec3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agenthud --version")

    output = shell_output("#{bin}/agenthud report --format json")
    assert_match '"date":', output
    assert_match '"sessions": []', output
  end
end
