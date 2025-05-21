class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.80.2.tgz"
  sha256 "58744c8adc80cb5128ea35a177694bcbddb075ed3ee02510c38868151dcb408c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "96904831ca1b3505bb5fb3dcb08ad55b097050ef75e359914a70b599aeafb826"
    sha256 cellar: :any,                 arm64_sonoma:  "07a745929665131ab755bf86afd04c650e84d79c7d9d539549c6d81020ad7640"
    sha256 cellar: :any,                 ventura:       "be74cc3f497a0fe238f822f97f02fd4af21cb87c9a41b8d61c664c82e58ecad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea73d22f2e4496d7f54c996b4df13aa1aa34b8df9ae1f79ab892fe44cc4d1ba9"
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
