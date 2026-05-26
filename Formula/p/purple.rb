class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.18.3.tar.gz"
  sha256 "7212224a8849ec9c038ad893b8b0e48f4319783cd402cbbcf77c3cbe7f6296e1"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b1f0b13104c786c3de9cd18bbec115a69ae46c7c19051344600c7421470177e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5d9f623ccb77d5ffbaac5f640a15b0aea4697f49e0306f302531b2d2ae05216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6de0fc0e611ea3d0dc01853d6a53817c93a0f545baa67a5a9be67e27265fa446"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26b0cf4edf0febd106f5fcffd74c54c8412987acef5600d8ad3beaee5551ff58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be0d4d52aa385562900e2849a01e27c29fda356a446208ee06c0d5d725de5d7"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
