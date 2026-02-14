class Lin < Formula
  desc "Lazy I18N"
  homepage "https://lin.rettend.me/"
  url "https://registry.npmjs.org/@yuo-app/lin/-/lin-2.1.0.tgz"
  sha256 "d3172928f3a279b1d4207bd7bc1167aab2e972d623fd100763e250381fa915bb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd90fc4c4611b1daa835b79e725dec6f3ea83a40978b3aa873e2804d5ea54ae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cca5e8cdf14b307f751c0d6efd10fd9b0804b5db86c10e661e35e137dd643e4"
    sha256 cellar: :any_skip_relocation, ventura:       "137f9bd1e9e496ce7978c11c89076957284e062a7ba96667de039af30beaa039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55161b4267fb88ee1e972743736d87d8098921df5a496c736eaf0669ee3bd304"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lin --version")

    output = shell_output("#{bin}/lin models")
    assert_match "Available Models", output

    output = shell_output("#{bin}/lin check")
    assert_match "All keys are in sync", output
  end
end
