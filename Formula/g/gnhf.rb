class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.13.tgz"
  sha256 "24da98042b9de2d4177a030e975fa06b06e5cdb240ac34f6e158264dccb27709"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "4e9ae5a98f3dfb7cde3ce8b80e485f0fcbce0b5d5c84f03f965a6a5511427694"
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
