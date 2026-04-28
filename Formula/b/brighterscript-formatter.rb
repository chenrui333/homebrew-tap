class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.17.tgz"
  sha256 "03354916acd1de1ab71de91f62f49b995a3f92e7c1d57c570b67cca5f0476e96"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f94cf220f4be30a715e0c0f21acdd2b0be3865cc6fd0c0425fd6d0af914cb34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00b84005e1e403b02a7f8d37ba2031fa2eaa94543c6ac58ea2eb08147840bac8"
    sha256 cellar: :any_skip_relocation, ventura:       "fed58aa1f1316e4c797db21a7b0f85ec72ba6d126338c04a1d3a7067ed397f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2255d42a67c5c79a98335c8838c1fa965a51277d71d0a1abbe6cbdd8ead98bca"
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
