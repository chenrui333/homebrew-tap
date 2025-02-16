class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.74.tgz"
  sha256 "479067e978a98c8063584d9b9916ea8ade4f559fd23557a66a07e7014c03c090"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "841ae0e14b1c47057cf268379484909deab16ce22c19699f42881adcea05cc6a"
    sha256 cellar: :any,                 arm64_sonoma:  "5359606e8d57e9cb14999f08d8f472f5bc445ca3b571743512500e7936c7f5f4"
    sha256 cellar: :any,                 ventura:       "7a0058ec3f67473cd09ed68f5c6f5c88c3c9294df4188a91fb9c50b24bc3db36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "525ae8944bd844f0296355e73e506ebea043f20372517a50138cea5215d60510"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/yuque-dl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yuque-dl --version")

    assert_match "Please enter a valid URL", shell_output("#{bin}/yuque-dl test 2>&1", 1)
  end
end
