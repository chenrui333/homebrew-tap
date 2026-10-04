class Keyhunter < Formula
  desc "Find leaked API keys in websites"
  homepage "https://github.com/DonIsaac/keyhunter"
  url "https://github.com/DonIsaac/keyhunter/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "dc377e67f3593e710f17159f3fcfd2c6f60591cd908a294f9ea7f3a50a9f42fa"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43f6cf7b7eda4355e466a7b40ea488f98d3a27091e1d5575a0a97164a73532d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c67f96a41f1ea1b2e66bff15b43e760d748a3412abd039f68db3a8d6ec0efc0e"
    sha256 cellar: :any_skip_relocation, ventura:       "bf3badd300e0070ee50f56ab3bf04f1a74f6f2a6a6ecfc91da2ab15a37a07fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37bf73fa0a47f5934e32745bad4890e27cc93ed662dace0220f11c52b8955625"
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
