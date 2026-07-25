class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.14.1.tar.gz"
  sha256 "d641b2b2d78f24d48f1eaaf200ea869b710edf6718b90baeaf42b2f345b50ae8"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "602b79626c960081a157de3cc2406db630a7354dd01572cbe8f873c286a8c798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "602b79626c960081a157de3cc2406db630a7354dd01572cbe8f873c286a8c798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "602b79626c960081a157de3cc2406db630a7354dd01572cbe8f873c286a8c798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2eae68bd43e45b4a820916ab6bc8c76adc4b838d53abea654ef38ceaad512f8"
    sha256 cellar: :any,                 x86_64_linux:  "a0f6da6a83b5bec2a1b2848373c8929f01baf0d0c18ed67b06200b74a7b97ce5"
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
