class Pixeli < Formula
  desc "Merge images into customizable grid layouts"
  homepage "https://github.com/pakdad-mousavi/pixeli"
  url "https://github.com/pakdad-mousavi/pixeli/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "a001c6a9780b983528417e724afd9860b8e7b4aa3786fccf71e8817d4ff36d33"
  license "MIT"
  head "https://github.com/pakdad-mousavi/pixeli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "09f83231693311b12af64e885e60825ddf65921229c549996cbeeb7a4b422cc7"
    sha256 cellar: :any, arm64_sequoia: "09f83231693311b12af64e885e60825ddf65921229c549996cbeeb7a4b422cc7"
    sha256 cellar: :any, arm64_linux:   "e7433532396ff6265472a73dbd3a31e4a5ea17abfeb572d2e7ac8e3a93e57ab5"
    sha256 cellar: :any, x86_64_linux:  "ac78354fea64ce8315d75bd37aee4ac6887e0c6b067732714952c33ba8c8a35c"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "ci", "--no-audit", "--no-fund"
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "run", "build"
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

    bin.install_symlink libexec/"bin/pixeli"
    pkgshare.install "src/tests/test-images/small-image.jpg",
                     "src/tests/test-images/large-image.jpg"
  end

  test do
    output = testpath/"out.png"

    assert_match version.to_s, shell_output("#{bin}/pixeli --version")
    system bin/"pixeli", "grid",
           pkgshare/"small-image.jpg",
           pkgshare/"large-image.jpg",
           "-o", output,
           "-c", "2",
           "-w", "100",
           "--gap", "0"

    assert_path_exists output
    assert_operator output.size, :>, 0
  end
end
