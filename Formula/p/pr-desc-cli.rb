class PrDescCli < Formula
  desc "AI-powered PR description generator"
  homepage "https://github.com/chalet-dev/chalet"
  url "https://registry.npmjs.org/pr-desc-cli/-/pr-desc-cli-2.0.1.tgz"
  sha256 "e5df3d3f50921236302ba2af33b417ea281edebd1881eda8d55db5f7fc24e4a9"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pr-desc --version")
    output = shell_output("#{bin}/pr-desc models")
    assert_match "llama-3.3-70b-versatile", output
  end
end
