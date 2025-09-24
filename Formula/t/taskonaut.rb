class Taskonaut < Formula
  desc "Interactive CLI tool for exec into AWS ECS tasks"
  homepage "https://github.com/SchematicHQ/taskonaut"
  url "https://registry.npmjs.org/@schematichq/taskonaut/-/taskonaut-1.7.2.tgz"
  sha256 "0e9693a74cfb8f92cc221420bc9d30a3af1daa06e9a3705912f0272d5a2074cd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bb2d5c67688174132d36724ac49d32ca1c99d23ec298bf7dc1a649895055bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46e30c136f0471d1ce92cecc2fc6d7e97997d84c5a971200a530cf3e62474154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ce31b109375711f4ba77637c2616dbb7e9b4f152a7c4774aba17e92af08ad3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/taskonaut config show")
    assert_match "\"awsProfile\": \"default\"", output

    output = shell_output("#{bin}/taskonaut doctor 2>&1")
    assert_match "❌ AWS profile 'default' is not configured", output
  end
end
