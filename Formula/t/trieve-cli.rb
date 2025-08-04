class TrieveCli < Formula
  desc "CLI for interacting with the Trieve API"
  homepage "https://docs.trieve.ai/getting-started/introduction"
  url "https://registry.npmjs.org/trieve-cli/-/trieve-cli-0.0.6.tgz"
  sha256 "32ea5734673d82a3f34d45539ef40b2cae7945232dfef9fdf227903171b97b43"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trieve --version")

    output = shell_output("#{bin}/trieve check-upload-status")
    assert_match "No files have been uploaded yet", output
  end
end
