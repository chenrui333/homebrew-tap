class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.85.4.tgz"
  sha256 "fa9b996232a3870b9a8bc3c77e355f6e8622b5a854690b1faba95e92f5bd4054"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "74fa9b4498983f939d8f28c701b93368217c11b6e3b205565237667aa6fd6583"
    sha256 cellar: :any,                 arm64_sonoma:  "bdfb2d515bb00939d53f7ee290a13a78c52a476b4c38aded1c89cf4358442bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e302f11639473d17ee01cb31719356395c3d9d7c4ee189ec452cd5940a4806"
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
