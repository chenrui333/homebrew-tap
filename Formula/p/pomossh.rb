class Pomossh < Formula
  desc "Terminal pomodoro timer with optional SSH mode"
  homepage "https://github.com/sairash/pomossh"
  url "https://github.com/sairash/pomossh/archive/refs/tags/0.1.1.tar.gz"
  sha256 "0ac8aa75f03f6098138d5322d901ebf8dfff3c7e069d9f35394868032ed252df"
  license "AGPL-3.0-only"
  head "https://github.com/sairash/pomossh.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "socket"

    log = testpath/"server.log"
    pid = nil
    pid = spawn(bin/"pomossh", "-ssh", out: log.to_s, err: log.to_s)

    port_open = false
    10.times do
      TCPSocket.new("127.0.0.1", 13234).close
      port_open = true
      break
    rescue Errno::ECONNREFUSED
      sleep 1
    end

    assert port_open, "pomossh SSH server did not start"
    assert_match "Starting SSH server", log.read
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
