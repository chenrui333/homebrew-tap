class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.16.tgz"
  sha256 "3926964f796019bbf5f5f82b194d57167e9f5868118b292619e902b7671972eb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33a42e0891257f51dfff885d18dc2ea8d5c46cafcf8e359fc3ed265bb9712de8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60d7a1e4ccc11f277155249dd1bf1b80137491f2f25a745b53aa85a2ce66b6b"
    sha256 cellar: :any_skip_relocation, ventura:       "73791311b207b21282925643ffc659ea5173cec05d732cd96c9875d8f9986311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1ccce9f829018ecd09b5e2dfcbb6be034f085628c718e38e12438c4fb3d38f7"
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
