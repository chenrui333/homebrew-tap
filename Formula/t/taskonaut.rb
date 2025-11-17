class Taskonaut < Formula
  desc "Interactive CLI tool for exec into AWS ECS tasks"
  homepage "https://github.com/SchematicHQ/taskonaut"
  url "https://registry.npmjs.org/@schematichq/taskonaut/-/taskonaut-1.10.3.tgz"
  sha256 "027b4fc8d7a1aacb52e0b72740bc27fc5e8dd30d0fe4057c3065ef54c7606d92"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "c932d4388bb7b59e0e9608e96e13807c781173f1e9a38da210a273986cccd59c"
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
