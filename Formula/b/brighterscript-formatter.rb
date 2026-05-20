class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.26.tgz"
  sha256 "6a7a02a3fe36c8edc7978dd75dcaf288db8734ea189f1236f1cd32fdb2dbfedc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ed495a0aa233ffffb910f00d455e6b031e6f61e5f26e443d799a09483212df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed495a0aa233ffffb910f00d455e6b031e6f61e5f26e443d799a09483212df3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed495a0aa233ffffb910f00d455e6b031e6f61e5f26e443d799a09483212df3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ff29e20b9c551b2fcfd078488d4ab9aeb537227906cc6f68268234789d05069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff29e20b9c551b2fcfd078488d4ab9aeb537227906cc6f68268234789d05069"
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
