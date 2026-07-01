class BrighterscriptFormatter < Formula
  desc "Code formatter for BrighterScript (and BrightScript)"
  homepage "https://github.com/rokucommunity/brighterscript-formatter"
  url "https://registry.npmjs.org/brighterscript-formatter/-/brighterscript-formatter-1.8.1.tgz"
  sha256 "87d4236550cda3dc51f75e299aa2568b57b17a8e06fa4d8a175b877685ab1eeb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac7f607dba8374c2a8cb9a7c095671fae5467e81484d753a00a42108a762b427"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac7f607dba8374c2a8cb9a7c095671fae5467e81484d753a00a42108a762b427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac7f607dba8374c2a8cb9a7c095671fae5467e81484d753a00a42108a762b427"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c911a4399a4bda9214cb10e07dc2e9d74dda0eb06032242261a7a96e87fc2c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c911a4399a4bda9214cb10e07dc2e9d74dda0eb06032242261a7a96e87fc2c68"
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
