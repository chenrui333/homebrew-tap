class Tunnelto < Formula
  desc "Expose your local web server to the internet with a public URL"
  homepage "https://github.com/agrinman/tunnelto"
  url "https://github.com/agrinman/tunnelto/archive/refs/tags/0.1.18.tar.gz"
  sha256 "100a8364d8fa4ac66e20f34b781c7b3fcee852eaa1e2ee29a05d40e4178269d2"
  license "MIT"
  head "https://github.com/agrinman/tunnelto.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47488136cdf30e5fe1643e247dda2f11f25bb95ca83531e6620055b8ba2cfa9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea6c8fb06ffe4afbccfa1b9e79fb0e476e612c44dbaacf70f325e4f08f6344a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "772d5b7d4c24a8dcce1dfce159739d541329e904b7f406a20656738b41e5b146"
    sha256 cellar: :any,                 arm64_linux:   "6971bdfa821755775a13296cc7d81880327a31bf6bb11616b2bd518c5d45721b"
    sha256 cellar: :any,                 x86_64_linux:  "c05d41afbf2015427dda7b1471cbdffe501b5ee1a757ca0ab379b694087efc53"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "update", "-p", "openssl", "--precise", "0.10.68"
    system "cargo", "update", "-p", "openssl-sys", "--precise", "0.9.116"
    system "cargo", "install", *std_cargo_args(path: "tunnelto")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tunnelto --version")

    help = shell_output("#{bin}/tunnelto --help")
    assert_match "expose your local web server", help.downcase
  end
end
