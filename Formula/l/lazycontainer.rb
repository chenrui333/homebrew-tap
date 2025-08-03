class Lazycontainer < Formula
  desc "Fancy terminal UI for Apple Containers"
  homepage "https://github.com/andreybleme/lazycontainer"
  url "https://github.com/andreybleme/lazycontainer/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "c674297ccb1c3897865e4dd14d64ce7346f04f66430c125ad6c8bdfff0ba4228"
  license "MIT"
  head "https://github.com/andreybleme/lazycontainer.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    require "pty"

    PTY.spawn(bin/"lazycontainer") do |r, _w, pid|
      out = r.readpartial(1024)
      assert_match "Error listing containers", out
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
