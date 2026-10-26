class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.16.0.tar.gz"
  sha256 "08c632384c38b97fe5cde364af388401750e8a0a58d729fbf2cdefb456554027"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "840b792fcef9b4c05dbd8164d8afef10ac9b601dbcec249cef0633b63de82915"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840b792fcef9b4c05dbd8164d8afef10ac9b601dbcec249cef0633b63de82915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "383e30abf8ed17161ee752e437994bdd24d331ad5abb0b6015ea1993fe7cba1d"
    sha256 cellar: :any,                 x86_64_linux:  "851b2fa52c35f3dfd65d52274d3cefd84a75705da1e8debd8992a135fa0d84c2"
  end

  depends_on "go" => :build

  # The test runs podcli's HTTP health check against a local loopback server.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/stefanprodan/podinfo/pkg/version.REVISION=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/podcli"

    generate_completions_from_executable(bin/"podcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/podcli version")

    require "socket"
    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]
    thread = Thread.new do
      loop do
        client = server.accept
        client.readpartial(1024)
        client.write("HTTP/1.1 200 OK\r\nContent-Length: 2\r\nConnection: close\r\n\r\nok")
        client.close
      rescue IOError, Errno::ECONNRESET
        break
      end
    end

    begin
      output = shell_output("#{bin}/podcli check http http://127.0.0.1:#{port} 2>&1")
      assert_match "check succeed", output
    ensure
      thread.kill
      server.close
    end
  end
end
