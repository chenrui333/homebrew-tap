class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.5.2.tgz"
  sha256 "31aad0ae339a9cccb9d8b9ac7434ab51b6039fc3e8118e0a681e9ee4de044118"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bfa13db1957d4f4fec595b1337ba7105dc9bb7d695ffc756ebf0cb1f33cd1a7d"
    sha256 cellar: :any,                 arm64_sequoia: "bfa13db1957d4f4fec595b1337ba7105dc9bb7d695ffc756ebf0cb1f33cd1a7d"
    sha256 cellar: :any,                 arm64_sonoma:  "bfa13db1957d4f4fec595b1337ba7105dc9bb7d695ffc756ebf0cb1f33cd1a7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a86c1a3e48f3ef4133b6b69f17591780a9da1cf812cedb57d4d87aa92c1558a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6fec4ee5877df9c797f0b0cd862f20e7b21223402a8f589a1dbcd6b60449ef8"
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
