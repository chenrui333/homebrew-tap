class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-1.12.2.tgz"
  sha256 "f98dd20ade48fa1b1b764cd45dd4e3a7a45056b5f4b069b9d27a1cce75dfbb3e"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "4b0d543c0c5883d6bca1cd293ed7806fe28afb198c2266f15af1ab20a3a71f40"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dominds --version")

    output = shell_output("#{bin}/dominds man ws_read --lang en --topics index")
    assert_match "Toolset manual: ws_read", output
  end
end
