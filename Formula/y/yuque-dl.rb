class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.81.tgz"
  sha256 "41039640509fd213938a7c412fec8a43492d52d30bf3fbdcf5f34c905c7a5b8c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "276ca23021dd9fed6648a8ea7bb511d82cafc9a5e7d008da551291340ac080c2"
    sha256 cellar: :any,                 arm64_sonoma:  "770eec23a229705293bab23d3f9b50a2bd871b03b1d9cef17e92c7fee401c59a"
    sha256 cellar: :any,                 ventura:       "ce289160e3ea0e93684acaba7132935f291b3035944a29df683d5e7cb0ca6ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf6aa39d8962a91741c714188221ac529a6180891fba3d35d9f9a2ac5dad381"
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
