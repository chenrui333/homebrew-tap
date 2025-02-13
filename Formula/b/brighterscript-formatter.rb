class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.10.tgz"
  sha256 "e65a2cab2fb557cb0460abe6f47a1d41b9819e3301b3031e0b831779964ff1ee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9478237b344a159e2cc7d2d35272ad2fc504985159f10d15305a78bc02aad2f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81c3e8885cbf7bf6e565583282081840fc7eb909a82c4f83316ed0f68e23f622"
    sha256 cellar: :any_skip_relocation, ventura:       "aaabbd347e224e5ed0766a9a84d9919c64cb60d2460a98e75c42639c30fe97ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ae2acd07bb412ae0a5cf4078266581155e8f8da65758f965496442dfeb972c"
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
