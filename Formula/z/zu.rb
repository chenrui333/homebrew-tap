class Zu < Formula
  desc "Minimalist key-value DB with disk persistence and in-memory cache"
  homepage "https://github.com/539hex/zu"
  url "https://github.com/539hex/zu/archive/refs/tags/v0.5.0-alpha.tar.gz"
  sha256 "103d820a6ede88b39e442dc3ce57302953a3c7ad9e37d3fd723a756cbe995249"
  license "BSD-2-Clause"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "zu"
  end

  test do
    output = pipe_output("#{bin}/zu", "help\nexit\n", 0)
    assert_match "Starting in-house REST server on port 1337", output
  end
end
