class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.93.1.tgz"
  sha256 "1f4ac75d12135d5b08f9c38728557194b763057303fbdfa0b0fca40c8b97e45e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e482aa99899c31ddff50f1c07b6a23f464a2329b8b2d165a0eab584b334d32a6"
    sha256 cellar: :any,                 arm64_sequoia: "03105651afd0cd49ee13e4dc77fe4f0842139705d6ea7c611417304898c7dfe6"
    sha256 cellar: :any,                 arm64_sonoma:  "03105651afd0cd49ee13e4dc77fe4f0842139705d6ea7c611417304898c7dfe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1daab008e51fbd020edbf85379a9db6336d33f45dd41f1a04269ab181cb93945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "495a3d03500e825c266f4e945347996a3a2b0dc11c2b141dbd9015a8cc7b638f"
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
