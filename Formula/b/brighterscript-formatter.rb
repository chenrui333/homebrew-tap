class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.8.3.tgz"
  sha256 "1d10fffa34e3ff21223ef0649fa263ee6e2df19b16fb2baf775f2b5e59526dad"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74bd5a32861359a3ed5a40dada6ab39734574550039ed8a015e431f4064e4e67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74bd5a32861359a3ed5a40dada6ab39734574550039ed8a015e431f4064e4e67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c897638a2bb8b9f6a5fed1f00beb444d6f6fd486060dcc0fdb658a5ad9996e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c897638a2bb8b9f6a5fed1f00beb444d6f6fd486060dcc0fdb658a5ad9996e3"
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
