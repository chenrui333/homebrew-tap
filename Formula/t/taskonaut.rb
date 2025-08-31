class Taskonaut < Formula
  desc "Interactive CLI tool for exec into AWS ECS tasks"
  homepage "https://github.com/SchematicHQ/taskonaut"
  url "https://registry.npmjs.org/@schematichq/taskonaut/-/taskonaut-1.7.1.tgz"
  sha256 "8611eebb7070146c503285b544bf01748b878f461e394909ccecc1e74ca2c89a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34d303264f9d62b70d12a03360799ea8296dd36f40749243ae2d6233231e3751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4397d8f5f54a671aa4e46783b3000e3ba8f80bc737c41c5810db45075eccb1"
    sha256 cellar: :any_skip_relocation, ventura:       "4e1a97c44fbf68c7f02153d3fafe2bc2f795c977c55ece63f971bad750b57a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6fc48cbcfbe69b63de16b89b64055537acbf2110f39d4547e9f74cc83bef0b0"
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
