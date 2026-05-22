class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.12.tar.gz"
  sha256 "271c5594477e0d6104aa7a4b20bb7aa0399ea5cd870395d981a893c516305cc2"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9bc8c57ab802f39148c13933189ef2dd3bcb6d9711ae1393bed4ada36b41c67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1597e48c0a78fffa339940d7da51c86bc7d3222328243352b54b443dfc28838a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d32a6da3eb37cef8b5df8bae11a6628014c8b1ce30b95eaca27870cd5a8a2a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "730d99babca2c6459790b140255080983cf4f0418ba48ecd4b820fc4beee7706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "274bacb7b45e89a871290498137d5f764a15f0d8664911d221d73140f95a8bdf"
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
