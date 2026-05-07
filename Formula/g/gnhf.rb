class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.40.tgz"
  sha256 "e9f14e9230029a4597e74cd206b5a98f5ca2da7f287be4d381724a5c5546ecc8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "814f6e4e0c58a7883c1d556ccd5e7daf9e5442b6cdbce5b4db1a4650682dd8e3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnhf --version")
  end
end
