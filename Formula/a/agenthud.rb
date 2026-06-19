class Agenthud < Formula
  desc "Claude Code TUI dashboard for parallel sessions and sub-agents"
  homepage "https://github.com/neochoon/agenthud"
  url "https://registry.npmjs.org/agenthud/-/agenthud-0.19.0.tgz"
  sha256 "b680199be1fc4c2fe6a602ce345d382887e2f8dfc5624314be16a543b9acf5e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "902ccc2dd5ef7d391e0969c1f2a3f9fc01f136737c3d2919e391479a8ca6e796"
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
