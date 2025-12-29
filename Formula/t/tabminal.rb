class Tabminal < Formula
  desc "Cloud-Native, Proactive AI Integrated Terminal works in modern browsers"
  homepage "https://github.com/Leask/Tabminal"
  url "https://registry.npmjs.org/tabminal/-/tabminal-1.1.21.tgz"
  sha256 "6e35c8d8ebf03609c656ff992386b2368fb25e993ca0994920de99683e13ee4a"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/tabminal --openrouter-key YOUR_API_KEY --accept-terms 2>&1", 1)
    assert_match "[SECURITY] No password provided. Generated temporary password", output
  end
end
