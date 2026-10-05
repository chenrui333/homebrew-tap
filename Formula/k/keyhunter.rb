class Keyhunter < Formula
  desc "Find leaked API keys in websites"
  homepage "https://github.com/DonIsaac/keyhunter"
  url "https://github.com/DonIsaac/keyhunter/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "dc377e67f3593e710f17159f3fcfd2c6f60591cd908a294f9ea7f3a50a9f42fa"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dc0c659e31bb4d7388f27578586f66aeccb20b776eb56edf3d80a56484cee41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05c10a97c9da8bee0e8217b024ceea9e48c89a5dade48af4ba6567ea5c1b7298"
    sha256 cellar: :any,                 arm64_linux:   "ec1d8c40bcf700eedec9c75ff39d5f615ced4fe48894a793fa46cbd8c3d10643"
    sha256 cellar: :any,                 x86_64_linux:  "91c2e9a76e2faf0f2f2af028427fa89969a11196a20e928b58f4fd615931725e"
  end

  depends_on "rust" => :build

  # keyhunter only scans websites over HTTP (no file input), so the test crawls a loopback server.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--features", "build-binary,report", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keyhunter --version")

    token = "ghp_#{"a1B2c3D4e5" * 3}abcdef"
    pages = {
      "/"       => ["text/html", '<html><body><a href="/about">About</a><script src="/app.js"></script></body>'],
      "/about"  => ["text/html", "<html><body><p>About</p></body></html>"],
      "/app.js" => ["application/javascript", "const token = \"#{token}\";\n"],
    }

    port = free_port
    server = TCPServer.new("127.0.0.1", port)
    thread = Thread.new do
      loop do
        client = server.accept
        path = client.gets.to_s.split[1]
        while (line = client.gets) && line != "\r\n"; end
        type, body = pages.fetch(path, ["text/html", "<html></html>"])
        client.write "HTTP/1.1 200 OK\r\nContent-Type: #{type}\r\nContent-Length: #{body.bytesize}\r\n" \
                     "Connection: close\r\n\r\n#{body}"
        client.close
      end
    end

    output = shell_output("#{bin}/keyhunter --format json http://localhost:#{port}")
    findings = output.lines.map { |line| JSON.parse(line) }
    assert_includes findings.map { |f| [f["rule_id"], f["secret"]] }, ["github-pat", token]
  ensure
    thread&.kill
    server&.close
  end
end
