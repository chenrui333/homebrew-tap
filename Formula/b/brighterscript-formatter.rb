class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.16.tgz"
  sha256 "3926964f796019bbf5f5f82b194d57167e9f5868118b292619e902b7671972eb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90d3d7acad1b1a539e1aaf9a7e1d50a28850facf730c35e21d9d493fc8c50847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f1e398d81c98554629f2aa4d3b5aa010254b8e5c86844c58f8ec660a1e7f24"
    sha256 cellar: :any_skip_relocation, ventura:       "a25a27406f0e346fc481d738f9d6ec365258f835896bfb621ea8ffdf3d60823c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62127105ad90960344c20b5fbc16ddb89c9471ecacee72288bff31f02b2a8be2"
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
