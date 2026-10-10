class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.8.4.tgz"
  sha256 "fc5dc338d3ab0a8c991844594d9aa6a74dc8005de33b21147fc6c3c4fa854697"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9ea8fbbd83de0f343f5336d4f19cd9fe59097693213b19f1438ce3cdb936cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9ea8fbbd83de0f343f5336d4f19cd9fe59097693213b19f1438ce3cdb936cd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f31d163acbe90cc14b93c2063ed9a72ffdb9172b203ba15037c1b5ed043b4222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31d163acbe90cc14b93c2063ed9a72ffdb9172b203ba15037c1b5ed043b4222"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
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
