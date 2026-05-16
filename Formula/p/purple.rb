class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "432cfaabd6998443ee3672ed30261719d0e1bed53724d8e4bcc76757783d08f0"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d78cc66c3110cdf0c304df8752e3784ba423a5f613e073257d74b2e891996632"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7bd07486bb124102a9e2db90bd5eeb58413c869bcb82a195d4cb74878d29e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f63e02dba296569d51cd88f6ad8db105d3d0ff47f85998fbafb3467c17892961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "550f7fe5e1e440b1927b2b351438fc3c49458381109cbbb00109140c34f92f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4522154b92ba9913720e5a795d4977b9fe7efb32c4967fe63b66bcff4ea267"
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
