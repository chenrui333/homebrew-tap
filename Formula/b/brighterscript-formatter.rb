class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.11.tgz"
  sha256 "6c4a7949ae68677a82d536f84624f6504db19cde03918908dcfc7f457568596c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27568522e61a7d47cf58eed437d4154738813e6c3448820e39715a08943bd9fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83f1dde932e060d290e7ab26aa7d1f4b2a0438fd8e6e45d1edcdf196e83a02bb"
    sha256 cellar: :any_skip_relocation, ventura:       "c459706084d0d07536453ebf4468d723c2a24a5e6cbae78d419a82c017879c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86ba18a8e50ec3b2d1e6f45103a36964ecdf5d1509a765eaa2c9f7c1c60e4253"
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
