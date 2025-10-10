class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.19.tgz"
  sha256 "57329cad7d8692b230e9702b7099926f88d1b2b087d30aefb02d744f1266683c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53dcd7fd72b9a3a24a87ba99453c2d302c5f571900e55b72b89cc6fe7dd5944"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "039fc7ec568ddd3242855dff35759b1552327465de304604216b3560ac7bdac3"
    sha256 cellar: :any_skip_relocation, ventura:       "1dda2de35a0d7e6eb96fe63f5e6839f1df5df461e6b27339d859d5a891d84391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b51ed6e14ee0174c2d9fe4e50eb5c1af21d9739fd9923df012d90456f9399268"
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
