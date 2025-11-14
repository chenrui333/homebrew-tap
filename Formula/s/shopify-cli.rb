class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.87.4.tgz"
  sha256 "a6fbc109e0759df9766ffdce268b5776f2f2800dbf8e06b2d3c7427c65bd6d02"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d05ac75f25851ebd8279cc49711998b7eb21dc2f967afbf67ed5971184a74220"
    sha256 cellar: :any,                 arm64_sequoia: "8b1864eac5ba1a41909cdae1135b9dfc3ae98f059e19b954e69330aca1f8a5d9"
    sha256 cellar: :any,                 arm64_sonoma:  "8b1864eac5ba1a41909cdae1135b9dfc3ae98f059e19b954e69330aca1f8a5d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6034d42c60d9bcd38b37e9efbca25a59a9cfcb8d580b02e819c58b38bfa0d362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfbefa7f4d6d6f07d9f9920d709539777ada4c53672d36ec3774d8df5ed4ef95"
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
