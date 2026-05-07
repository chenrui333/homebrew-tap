class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.669.tgz"
  sha256 "cecf9def5f2a24c09e3fb373521b71e1796353ea5c94d34a1e43d9eca090628f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "9fb70966ed7a97bfd70e8270b371812c0b1087c6792363590a6a906011e587ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match(/\b\d+\.\d+\.\d+\b/, shell_output("#{bin}/cb --version"))
  end
end
