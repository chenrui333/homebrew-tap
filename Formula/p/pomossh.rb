class Pomossh < Formula
  desc "Terminal pomodoro timer with optional SSH mode"
  homepage "https://github.com/sairash/pomossh"
  url "https://github.com/sairash/pomossh/archive/refs/tags/0.1.1.tar.gz"
  sha256 "0ac8aa75f03f6098138d5322d901ebf8dfff3c7e069d9f35394868032ed252df"
  license "AGPL-3.0-only"
  head "https://github.com/sairash/pomossh.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18d7a29c45840de0c3095797a0945793d002bb995a4f0c1af201124a27ac5513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d7a29c45840de0c3095797a0945793d002bb995a4f0c1af201124a27ac5513"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea455835ecb98af61b9bc28c29f706716eb7d5ee110a94482a0dab8baf5897a7"
    sha256 cellar: :any,                 x86_64_linux:  "7f79a9f5e372e3a70ecd44cde42ae794e22acf80c2c79f483a044e81320c772f"
  end

  depends_on "go" => :build

  # The test starts pomossh's SSH server and connects to it over loopback.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
