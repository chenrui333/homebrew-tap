class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-1.20.5.tgz"
  sha256 "5b633c56f0e85c89bae0fbf5868d605995085a83287564539c8e2a243b2f97dc"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "fdf93d1536e16b10ac6731c85e075f9892a80cc13ec4fbbac6b4f38266665635"
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
