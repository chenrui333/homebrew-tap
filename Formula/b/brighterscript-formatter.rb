class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.22.tgz"
  sha256 "256672796300d60c65c270b8657aef4624ead28136ca94d3d63c27ad16fb6bf1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b607cbd55822baaf9fce9b8118f6d406f8713b9c7465964a1fc9711834cc6c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b607cbd55822baaf9fce9b8118f6d406f8713b9c7465964a1fc9711834cc6c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b607cbd55822baaf9fce9b8118f6d406f8713b9c7465964a1fc9711834cc6c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64139f2df5d42936acb26694fa2c91420d0febf89b9460db2135ea201b2f87da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64139f2df5d42936acb26694fa2c91420d0febf89b9460db2135ea201b2f87da"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/brighterscript-formatter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brighterscript-formatter --version")

    (testpath/"test.bs").write <<~BRIGHTERSCRIPT
      sub Main()
      print "Hello, World!"
      end sub
    BRIGHTERSCRIPT

    system bin/"brighterscript-formatter", "--write", testpath/"test.bs"

    expected_content = <<~BRIGHTERSCRIPT
      sub Main()
          print "Hello, World!"
      end sub
    BRIGHTERSCRIPT

    assert_equal expected_content, (testpath/"test.bs").read
  end
end
