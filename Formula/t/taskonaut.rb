class Taskonaut < Formula
  desc "Interactive CLI tool for exec into AWS ECS tasks"
  homepage "https://github.com/SchematicHQ/taskonaut"
  url "https://registry.npmjs.org/@schematichq/taskonaut/-/taskonaut-1.10.13.tgz"
  sha256 "436b0abeac49e1828b23ca3bcf82962c76dc478152d012f1114f01bda1601ee5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "7f6d3ca466eb54b216252e26d73b0ab5e254314c3072bed5a4230292c2ecfeb1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/taskonaut config show")
    assert_match "\"awsProfile\": \"default\"", output

    output = shell_output("#{bin}/taskonaut doctor 2>&1")
    assert_match "❌ AWS profile 'default' is not configured", output
  end
end
