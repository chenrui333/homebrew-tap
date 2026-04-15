class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.23.tgz"
  sha256 "61cd4553784146ac6eff86781b3a5b488b899fa8caa00f78484123226a49f350"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf8d0e46e725d3f5143423d6b14a7b41b3307a1796e0d99f65b1c18f33fd9b4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf8d0e46e725d3f5143423d6b14a7b41b3307a1796e0d99f65b1c18f33fd9b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf8d0e46e725d3f5143423d6b14a7b41b3307a1796e0d99f65b1c18f33fd9b4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81efe05b7cd3983273bcc5847df7eff4a6c2cc1d27f906577a583ffe896ebc9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81efe05b7cd3983273bcc5847df7eff4a6c2cc1d27f906577a583ffe896ebc9e"
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
