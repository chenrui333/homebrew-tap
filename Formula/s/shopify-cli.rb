class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.0.0.tgz"
  sha256 "87b7f5dc3fcc210c41b742da36ccd9577331cd256ad527eaab821f4a17daaabd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bc4901862818f4abec6bcb30a51d9d8e225442ab3a630f2bffcaf84d60500ee9"
    sha256 cellar: :any,                 arm64_sequoia: "2b09f0c5dd7b3e1973ccda0e3162dd2bf58bb7ed9c394717e441369966669e5d"
    sha256 cellar: :any,                 arm64_sonoma:  "2b09f0c5dd7b3e1973ccda0e3162dd2bf58bb7ed9c394717e441369966669e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4fac5e53b9bcfc9595caa4ed596724f1e41a4007fbcd1e1b7567d8377938bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bd703a9fb9cafacb339d4e73ee94e4fbd9bcfc9caee7d5a481c764875a4d38f"
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
