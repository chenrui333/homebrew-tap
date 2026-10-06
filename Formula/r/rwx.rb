class Rwx < Formula
  desc "Manage Unix permissions and ownership"
  homepage "https://github.com/vncsmnl/rwx"
  url "https://github.com/vncsmnl/rwx/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "e7848a07e96fbed035e1ab3f32b6099a2c9457c7caa3863f97112cee57a9eae2"
  license "MIT"
  head "https://github.com/vncsmnl/rwx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "794c5ef6e52ea0373db36c410cde21faa2cc91e38cf33474df1bd5ca42843981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1485b419b01ec73a966ddb6059c899a792bd0f9c21203c86dfe55d212a031b4"
    sha256 cellar: :any,                 arm64_linux:   "870a15e581da13a33a4789b083281d4f9558a606dd655d9bc821917a24dfc0f8"
    sha256 cellar: :any,                 x86_64_linux:  "5c84b7300b74cb87bd92e77baa90f4f46de9d060e85bdee5b5686fa8a767ffd6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rwx --version")
    output = shell_output("#{bin}/rwx --invalid-option 2>&1", 2)
    assert_match "unexpected argument '--invalid-option'", output
  end
end
