class Httptap < Formula
  desc "View HTTP/HTTPS requests made by any Linux program"
  homepage "https://github.com/monasticacademy/httptap"
  url "https://github.com/monasticacademy/httptap/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dc6b99f20b1ab33f6801050a2367529a235c2b1a654d24f908b1f1bf62a36457"
  license "MIT"
  revision 1
  head "https://github.com/monasticacademy/httptap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "04223e455e65d76e78d69f0cc56f0e58f0e377234c839dac309e2f12e0749335"
    sha256 cellar: :any,                 x86_64_linux: "2b7d2ffb3ddc70689b7ebfc33e8e5c7c03da0d41ca48be204e6f9a12ba11b400"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "socket"

    server = TCPServer.new("127.0.0.1", 0)
    pid = nil

    begin
      pid = fork do
        client = server.accept
        client.readpartial(1024)
        client.write "HTTP/1.1 200 OK\r\nContent-Length: 2\r\nConnection: close\r\n\r\nOK"
        client.close
      end

      output = shell_output("#{bin}/httptap -- true 2>&1", 1)
      assert_match "operation not permitted", output
    ensure
      server.close
      if pid
        Process.kill("TERM", pid)
        Process.wait(pid)
      end
    end
  rescue Errno::ECHILD, Errno::ESRCH
    nil
  end
end
