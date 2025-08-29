class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.84.1.tgz"
  sha256 "0f4ebe3296ca3957b801a5815795c40dc69051de4859f8c89d8e3ff1447e9979"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "10eab79b9602a7ac5f0ebba65f884b0441e668711f89a2c5c083dfb3d9e8b82a"
    sha256 cellar: :any,                 arm64_sonoma:  "a23da4af2472ccedf9119ea92b713b2cbc85e42a5ad18e64421cb298752feb2c"
    sha256 cellar: :any,                 ventura:       "421e2f13a85b09c5fbb19e76502d506705a621095bf6976a09af059d29a1c4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d72ad78da609ce4ead88857ec889f8a1d05c0f07d599d980f6ed35afa390d17"
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
