class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.27.tgz"
  sha256 "7c7d96a42b9b8e330112f68f98eae834bf0dd421e8c6c9a4dedb540ed3489be0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd536958557b624177120f254735dd88bdc73cf80d9f3501f5a56a47b6515eca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd536958557b624177120f254735dd88bdc73cf80d9f3501f5a56a47b6515eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd536958557b624177120f254735dd88bdc73cf80d9f3501f5a56a47b6515eca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d943ede46e5837ce3e167ad7ef45a18aea949f8b44fefd8468d43d4fbc89efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d943ede46e5837ce3e167ad7ef45a18aea949f8b44fefd8468d43d4fbc89efe"
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
