class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.80.1.tgz"
  sha256 "98dae93b7761b87e920a3ac97f35fcefd7a350944ec722911bc670fe5e784d53"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "0b1e9262b84fc546483a4550b394e163c849614fcf57cba145f0864f7ddd4c68"
    sha256 cellar: :any,                 arm64_sonoma:  "f93cbdad67520e4f8510209de95584a5b17e5a57a412055888aa31c339f5618e"
    sha256 cellar: :any,                 ventura:       "9d053df83947e9fd1168c5ed468051d86a16765916b34f587b3f34bfe3a8fbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed20518fa645185c92ebb0ad9cfaa6de140e345c097b6488f3328880ff382de"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/shopify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shopify --version")

    assert_match "app build", shell_output("#{bin}/shopify commands")
  end
end
