class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-4.5.1.tgz"
  sha256 "397f8931046447b69dcc37aa0c180e1749d43105c79bc495a79dc4359d1071bb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "abe9aa134ace8f45b0520a64da70283231f4dc3fb1d830bcc8277ee5ca15fd26"
    sha256 cellar: :any,                 arm64_sequoia: "abe9aa134ace8f45b0520a64da70283231f4dc3fb1d830bcc8277ee5ca15fd26"
    sha256 cellar: :any,                 arm64_sonoma:  "abe9aa134ace8f45b0520a64da70283231f4dc3fb1d830bcc8277ee5ca15fd26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7e07d126634dcd4ccd774f300a4d66b13c8fee3a9f88a825b52f939cb2281c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e4de9547699b88d25876ad722b34c05696931726fdd5a267691f9fb1a78beab"
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
