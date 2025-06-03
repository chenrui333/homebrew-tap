class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.15.tgz"
  sha256 "f08c25e142958c8e80dee896bd32537da1fe7b6d4d2609efefc91ece2237f9fb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "088107c631546b89b3af9d05576ba4421fd9cef703cc22239c5696f6c053cc58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eecd03b7d4ee91dfb99f37eb8ec0bd19a6afcee6eadfbf88525c7ccc06855e08"
    sha256 cellar: :any_skip_relocation, ventura:       "c03d99240ba9f012bc4a08acd48476a5cc61341cf597328ae976d80638925107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac1aa228ca9b22bd84682375d8c1c6783098146605b51379de9869cf98ac7b19"
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
