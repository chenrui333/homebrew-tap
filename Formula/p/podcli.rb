class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.17.0.tar.gz"
  sha256 "60aff6f065b4ca17131392d7b3d1d6fc3466fa6fa8140b2b6636a86cc9ed24e1"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c1d2cdc5f7d288ac8a436f5696775147c29365f734810e3d5e76878ad015ee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c1d2cdc5f7d288ac8a436f5696775147c29365f734810e3d5e76878ad015ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93b58824f8235cdb61b06697b65f1af1dcd86a9d90c9f7ba5fad9071334b543c"
    sha256 cellar: :any,                 x86_64_linux:  "e0028a3fb300465c0508327d61dd9cf75ce7380cb55059049fb2d897b17f2839"
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
