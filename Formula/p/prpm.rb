class Prpm < Formula
  desc "Universal registry for AI coding tools"
  homepage "https://prpm.dev/"
  url "https://registry.npmjs.org/prpm/-/prpm-2.1.35.tgz"
  sha256 "02af29543ad95d8adfd40cb965308069d02fb35298696a001162bcbb8de637cf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "984d7c47d16bc2d240cbb8f5fdee4d1511347efb16d2fa2daac14b6819240c46"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prpm --version")

    system bin/"prpm", "init", "--yes"
    assert_path_exists testpath/"prpm.json"
    assert_match "A PRPM package", (testpath/"README.md").read

    assert_match "No packages installed", shell_output("#{bin}/prpm list")
  end
end
