class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.8.1.tgz"
  sha256 "87d4236550cda3dc51f75e299aa2568b57b17a8e06fa4d8a175b877685ab1eeb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b77555c21aa68284144b47be3573f08421d066a19fed08f03c00511753b5e1a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b77555c21aa68284144b47be3573f08421d066a19fed08f03c00511753b5e1a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b77555c21aa68284144b47be3573f08421d066a19fed08f03c00511753b5e1a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2ebb759f1352b81a5f8ccc4d43f4e6d5f3e876328f6d7ca0195f57117da3bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2ebb759f1352b81a5f8ccc4d43f4e6d5f3e876328f6d7ca0195f57117da3bc5"
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
