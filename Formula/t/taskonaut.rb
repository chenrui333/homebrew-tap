class Taskonaut < Formula
  desc "Interactive CLI tool for exec into AWS ECS tasks"
  homepage "https://github.com/SchematicHQ/taskonaut"
  url "https://registry.npmjs.org/@schematichq/taskonaut/-/taskonaut-1.10.5.tgz"
  sha256 "7f6b11e48e648616b2fac07cd1851654f4339b5bf01c7598552bc284fc840437"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0a65aa97d8728a64492326d95e3a3f2e43ae6dc8b20f1a07307e5b0aa2ca110c"
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
