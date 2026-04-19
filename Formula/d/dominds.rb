class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-1.17.7.tgz"
  sha256 "5f0300255a119bda538f9fd46e34cf5ec1832b95d53e37e47436e54d95ffc059"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b1f0b374f71f2dd334316df56b0c0019bbde703cd89f1cf3ab78aa9b5051fefd"
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
