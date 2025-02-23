class Percollate < Formula
  desc "CLI to turn web pages into readable PDF, EPUB, HTML, or Markdown docs"
  homepage "https://github.com/danburzo/percollate"
  url "https://registry.npmjs.org/percollate/-/percollate-4.2.3.tgz"
  sha256 "a14bba93972213434a383de1e1ce720fd53ccf67283179c14f347686ae2c0c90"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/percollate --version")

    # Since percollate requires Chromium, just do a error check in here
    output = shell_output("#{bin}/percollate pdf https://example.com -o my.pdf 2>&1", 1)
    assert_match "Could not find Chromium", output
  end
end
