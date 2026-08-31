class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.15.0.tar.gz"
  sha256 "8cb6bcd907a43bd67196ec3530771105f7d726116171b692a3b69717e4d0831b"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5893b344ee0bb925a9f84d90179563425dc5a98be3b48018f142cf30db63890"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5893b344ee0bb925a9f84d90179563425dc5a98be3b48018f142cf30db63890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5893b344ee0bb925a9f84d90179563425dc5a98be3b48018f142cf30db63890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908c545144c9ee5e727885bfcd433b02d5a5512f92ea81f79de08626e7cb248c"
    sha256 cellar: :any,                 x86_64_linux:  "ec32d32e4484fd145d7cc2b64d8300f8313674377073e36e040b4d0eab80f64c"
  end

  depends_on "go" => :build

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
