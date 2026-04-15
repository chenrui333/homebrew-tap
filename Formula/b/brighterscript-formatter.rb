class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.23.tgz"
  sha256 "61cd4553784146ac6eff86781b3a5b488b899fa8caa00f78484123226a49f350"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dc354838d187d914e9225c485e3b30d9807e9c3407f6f8bdd3e9057247abd97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dc354838d187d914e9225c485e3b30d9807e9c3407f6f8bdd3e9057247abd97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dc354838d187d914e9225c485e3b30d9807e9c3407f6f8bdd3e9057247abd97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fd37159f7db0eff2a830b5d071ead460b9dbe075a345e57f8d3b8fccbffb692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fd37159f7db0eff2a830b5d071ead460b9dbe075a345e57f8d3b8fccbffb692"
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
