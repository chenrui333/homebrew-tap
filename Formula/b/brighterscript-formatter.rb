class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.13.tgz"
  sha256 "840fdacd28659c06c9a9338996f6e1c9b83e4cf27dd9216902757b232ccd8348"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e850d5d0e64727c087f82323114ab327c84955185da6c1b684c2928014fb60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3c6cb5758e7698e375069eaa584d02ae4d294d0ae27114210057af11c85ad9a"
    sha256 cellar: :any_skip_relocation, ventura:       "2aac438ba63f981b3e157285f84e8041f9c699feeba89289efe18669d1dc3bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dad40012e94de1eda4065eeb79ab3aea35db021fd96bf1ae2bc3a270d85e5380"
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
