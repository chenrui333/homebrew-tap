class Zu < Formula
  desc "Minimalist key-value DB with disk persistence and in-memory cache"
  homepage "https://github.com/539hex/zu"
  url "https://github.com/539hex/zu/archive/refs/tags/v0.5.0-alpha.tar.gz"
  sha256 "103d820a6ede88b39e442dc3ce57302953a3c7ad9e37d3fd723a756cbe995249"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "739c32b3d7cbfe3d250f13b480db68e3834c928ac7c12e71b55a3e8352089c9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877b47945719dd820e50b5b90a91d836967c0feb1f7f85891321f2a2a0aafcb4"
    sha256 cellar: :any,                 arm64_linux:   "e8301b70771fd1e4f29efa216548d32250ca65d79d1a1f673b40f63cc9662761"
    sha256 cellar: :any,                 x86_64_linux:  "d6d9530297511603d9221e8d6c83e1ad35238be0e828e4c444e283b4c1cbc537"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "readline"
  end

  # zu always starts its in-house REST server on a local TCP port at startup.
  allow_network_access! :test

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "zu"
  end

  test do
    output = pipe_output(bin/"zu", "help\nexit\n", 0)
    assert_match "Starting in-house REST server on port 1337", output
  end
end
