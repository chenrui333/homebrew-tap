class Lin < Formula
  desc "Lazy I18N"
  homepage "https://lin.rettend.me/"
  url "https://registry.npmjs.org/@yuo-app/lin/-/lin-2.1.0.tgz"
  sha256 "d3172928f3a279b1d4207bd7bc1167aab2e972d623fd100763e250381fa915bb"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lin --version")

    output = shell_output("#{bin}/lin models")
    assert_match "Available Models", output

    output = shell_output("#{bin}/lin check")
    assert_match "All keys are in sync", output
  end
end
