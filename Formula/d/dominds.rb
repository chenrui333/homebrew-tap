class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-1.17.5.tgz"
  sha256 "bbddfad11117e6279fb3a67747d9401657e09c0c738aad4ae1470f0e062f8258"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "d584de75c7c1f1b4cf6b45be877b683c0c12e004aaa2ca44ea5411739c9bacf3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dominds --version")

    output = shell_output("#{bin}/dominds manual --list")
    assert_match "Available toolsets:", output
    assert_match "ws_read", output
  end
end
