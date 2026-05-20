class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.26.tgz"
  sha256 "6a7a02a3fe36c8edc7978dd75dcaf288db8734ea189f1236f1cd32fdb2dbfedc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3711af6808123970e2eea46d22538fc0becd93463cf38265bddb9ec74ea6fc4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3711af6808123970e2eea46d22538fc0becd93463cf38265bddb9ec74ea6fc4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3711af6808123970e2eea46d22538fc0becd93463cf38265bddb9ec74ea6fc4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "937ceadebd857f2cea95fa30ec3a6383f6d667863247a64e826b4ea29b4c7e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "937ceadebd857f2cea95fa30ec3a6383f6d667863247a64e826b4ea29b4c7e6f"
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
