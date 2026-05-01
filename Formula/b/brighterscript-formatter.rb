class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.7.24.tgz"
  sha256 "12286cd33803f4d7865cd1973b876506fd2499265c8c533330845d3ac2485625"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a45f3c7a0c4c07f4ff2ae4adf5e290b2eae184ebd02892ddafcdca3a26e0b8de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a45f3c7a0c4c07f4ff2ae4adf5e290b2eae184ebd02892ddafcdca3a26e0b8de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45f3c7a0c4c07f4ff2ae4adf5e290b2eae184ebd02892ddafcdca3a26e0b8de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70d2e0762436210637df00ed899485673eb8f54715284b3a77a3d91b3ed02004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d2e0762436210637df00ed899485673eb8f54715284b3a77a3d91b3ed02004"
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
