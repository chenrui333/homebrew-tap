class StyleDictionary < Formula
  desc "Build system for creating cross-platform styles"
  homepage "https://github.com/style-dictionary/style-dictionary"
  url "https://registry.npmjs.org/style-dictionary/-/style-dictionary-5.0.0.tgz"
  sha256 "f8ee73b6b55f75db63eab440f2a72a91efd2fb175baf168294dd067ed63e3bf5"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/style-dictionary --version")

    system bin/"style-dictionary", "init", "basic"
    assert_path_exists testpath/"config.json"

    system bin/"style-dictionary", "build"
  end
end
