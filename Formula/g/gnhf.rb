class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.25.tgz"
  sha256 "b9edb1d1da79ecdbb1d75f71ec03338797b40e7f86031d8486c94b925ac49f0d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "19dc47fb4c5081c3f2e3abbc19c7386b0be4e1a56ef0b8ba8186a6aa07a03f99"
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
