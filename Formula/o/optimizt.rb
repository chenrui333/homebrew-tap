class Optimizt < Formula
  desc "CLI image optimization tool"
  homepage "https://github.com/343dev/optimizt"
  url "https://registry.npmjs.org/@343dev/optimizt/-/optimizt-11.0.0.tgz"
  sha256 "0d155f6df0a74c31de0d825b4482f37e0b398e5e2a05033d8c56c749034fa80a"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/optimizt --version")

    output = shell_output("#{bin}/optimizt #{test_fixtures("test.png")}")
    assert_match "Optimizing 1 image (lossy)...", output
  end
end
