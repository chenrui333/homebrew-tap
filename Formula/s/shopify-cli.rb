class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.80.2.tgz"
  sha256 "58744c8adc80cb5128ea35a177694bcbddb075ed3ee02510c38868151dcb408c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "5a974f460d7cd5e38c3c9a40bd45a31aa731f306d4c720fda24e3c52422cc1f2"
    sha256 cellar: :any,                 arm64_sonoma:  "8685eab74c5e377dbae2ae79ea2d550572386634ae39e2de5d2b398b1986c645"
    sha256 cellar: :any,                 ventura:       "8bcb661e801952c97d84314bae0b8aa06723ab7525b0a3627910e7b49af41e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "652cbb7be73e3e8a524af755ccdebafd769511d705d6ac140e8066c420aab553"
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
