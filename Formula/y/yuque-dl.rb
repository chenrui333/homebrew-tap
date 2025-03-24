class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.77.tgz"
  sha256 "4a4b1223c6e48658aa003ac32b64b7b70e93724de7da1fb9b0de9eb7a6ed312e"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "eee4a522b388aada4d8411e302524ea88573afcf25d72ea77319152170127715"
    sha256 cellar: :any,                 arm64_sonoma:  "7df3571c5bd69f16bcedceedd569a3c6541d0a5defbfe8c56879229707843e34"
    sha256 cellar: :any,                 ventura:       "83b976502d00133af17061e93aaa520bd3151b7ef31589ea44db065f8f162536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7cf7bd44b31f365b414f129201ae218a7c3bbe970d87a7fd3d1d20dda90e4c"
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
