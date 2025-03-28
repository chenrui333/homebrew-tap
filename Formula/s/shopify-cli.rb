class ShopifyCli < Formula
  desc "CLI which helps you build against the Shopify platform faster"
  homepage "https://shopify.dev/"
  url "https://registry.npmjs.org/@shopify/cli/-/cli-3.77.1.tgz"
  sha256 "8be067b37046be61fb2d84fcab8db36508f54ad3a4eb1c9da07e9aef7fe43488"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "5d15dd94df5b1add0bd9e290b4595c7892ad103f06cadd9de177b1c0b282a89a"
    sha256 cellar: :any,                 arm64_sonoma:  "ae25610e79d32b4697a47c8825d7f643ca65cc387c4804bd684d98179449bc15"
    sha256 cellar: :any,                 ventura:       "b885837988482c3af0bbffa6267b2848508d283959e8fb2e6f7d98c5e14b8486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603a613882f8859fdd107a0716416bc7f0d550587319da5989b4b39636d6a599"
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
