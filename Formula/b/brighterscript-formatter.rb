class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.8.2.tgz"
  sha256 "4048f6ab86de159cb104ddc7ce80444c3d363ca7f95e95fb31ed0966a509d791"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc97d7a241ce8b49eda1139050ab1468d031f7088800722075a551f0976a3f05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc97d7a241ce8b49eda1139050ab1468d031f7088800722075a551f0976a3f05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc97d7a241ce8b49eda1139050ab1468d031f7088800722075a551f0976a3f05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7bbdcd0a34c6826f169a3020dbc626501df75947bc58998fce445613729c5e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7bbdcd0a34c6826f169a3020dbc626501df75947bc58998fce445613729c5e9"
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
