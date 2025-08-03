class CarbonNowCli < Formula
  desc "Beautiful images of your code — from right inside your terminal"
  homepage "https://github.com/mixn/carbon-now-cli"
  url "https://registry.npmjs.org/carbon-now-cli/-/carbon-now-cli-2.1.0.tgz"
  sha256 "7ad51db24caf6b79d77d9ee4407bee6a5ed0c6677014ae5ba0fb955fb7770083"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/carbon-now 2>&1", 1)
    assert_match "No file or stdin given.", output
  end
end
