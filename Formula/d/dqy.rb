class Dqy < Formula
  desc "DNS query tool"
  homepage "https://github.com/dandyvica/dqy"
  url "https://github.com/dandyvica/dqy/archive/refs/tags/v0.5.2.1.tar.gz"
  sha256 "83374237f15e8418e239684636b45b3d3de0233249166bfa3155c57c23d673d8"
  license "MIT"
  head "https://github.com/dandyvica/dqy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8fc546ffb292cf0185749d3eb3cee0ec2560afce18a0a0972be78a11b47daa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "905bfed8b212d1de1c1839e12fcb063a7ea4fda01600cd8875db9e310682719a"
    sha256 cellar: :any_skip_relocation, ventura:       "fcef4aa3cfdaa456b3fcb9d24e4e9d24ce4dca03b63e74981fb814fb21fe1f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "862f8bfea3c3b152ebb8e11474bba45fd2bda690d7e4ec0526ff0b98527b475b"
  end

  depends_on "rust" => :build

  # The test exercises a DNS query against a loopback UDP fixture.
  allow_network_access! :test

  def fetch
    # Upstream does not include Cargo.lock in release archives.
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "io/wait"
    require "socket"

    assert_match "0.5.2", shell_output("#{bin}/dqy --version")

    server = UDPSocket.new
    server.bind "127.0.0.1", 0
    port = server.addr[1]

    worker = Thread.new do
      raise "Timed out waiting for DNS query" unless server.wait_readable(10)

      query, client = server.recvfrom(2048)
      qname_end = 12
      qname_end += query.getbyte(qname_end) + 1 until query.getbyte(qname_end).zero?
      question = query.byteslice(12, qname_end - 7)

      header = query.byteslice(0, 2) + [0x8180, 1, 1, 0, 0].pack("n5")
      rdata = "\x02ns\x07example\x04test\x00"
      answer = [0xc00c, 2, 1, 60, rdata.bytesize].pack("n3Nn") + rdata
      server.send header + question + answer, 0, client[3], client[1]
    end

    begin
      output = shell_output("#{bin}/dqy NS example.test @127.0.0.1 --port #{port} --no-colors")
      worker.value
    ensure
      worker.kill
      server.close
    end
    assert_match "ns.example.test.", output
  end
end
