class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.14.2.tar.gz"
  sha256 "2f2e8745d46b5c49044b739b4579b899ad29030d1f0ef43493b24a4354eeb3f7"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61e9c21b8e261272d0b67c08483adb45da9808288ab674154509b545ebdaf73b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8230e853f0c8d1a7ce4388e386a5cbc2ac73804a96c6d206f2f3b0b5e1aa1746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d94783aabf00496d1609cb2d0391815a9c83a1d2119b9ed0b89b061520f5b76a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a91e6379dd3ddbe8f33dfcb6f05a5b1f54e1cb92e6c6f9d357aeab451b1bc5c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f679847ad2e3e3574980d2dc88aef1b352d23dc23ede6a71574c9eaebea7462"
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
