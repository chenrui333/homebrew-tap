class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.626.tgz"
  sha256 "4d7f86828f45ad563ea949fc32077d3ac96a387578e30cb6e07e0f954bf82a1c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "8e51c5dbdfb1080c2dba8bca4bba9de6c491bd02da66f2038c5dc7157757aa84"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cb --version")
  end
end
