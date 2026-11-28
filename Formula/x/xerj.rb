class Xerj < Formula
  desc "Local search engine and MCP server for code and documents"
  homepage "https://xerj.org/"
  url "https://github.com/xerj-org/xerj/archive/refs/tags/v1.0.0-rc.105.tar.gz"
  version "1.0.0-rc.105"
  sha256 "2e8c5ca54adcc8a9369b1c657a5f490c125aa76b122fb09ccb8436fe69b4999f"
  license "Apache-2.0"
  head "https://github.com/xerj-org/xerj.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-rc\.\d+)?)$/i)
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  # The test indexes and searches a document over the loopback interface.
  allow_network_access! :test

  def fetch
    cd "engine" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    cd "engine" do
      system "cargo", "install", *std_cargo_args(path: "crates/xerj-server")
    end
  end

  def caveats
    <<~EOS
      This formula builds the public engine. The proprietary Query-1 model
      features shipped only in upstream's release binaries are not included.

      On first use, run `xerj --data-dir #{var}/xerj` in a terminal to get
      the local setup link before starting the background service.
    EOS
  end

  service do
    run [opt_bin/"xerj", "--bind", "127.0.0.1", "--data-dir", var/"xerj"]
    keep_alive true
  end

  test do
    require "socket"

    port, grpc_port = TCPServer.open("127.0.0.1", 0) do |listener|
      [listener.local_address.ip_port, free_port]
    end
    config = testpath/"xerj.toml"
    config.write <<~TOML
      [server]
      es_compat_port = #{port}
      rest_port = 0
      grpc_port = #{grpc_port}
    TOML

    url = "http://127.0.0.1:#{port}"
    with_test_process(bin/"xerj", "--config", config, "--bind", "127.0.0.1", "--insecure",
                      "--data-dir", testpath/"data", "--embed-mode", "lexical") do
      system "curl", "-fsS", "--noproxy", "*", "--retry", "10", "--retry-connrefused", "--retry-delay", "1",
                     "--max-time", "3", "#{url}/_cluster/health"
      system "curl", "-fsS", "--noproxy", "*", "--max-time", "5", "-X", "PUT", "-H", "Content-Type: application/json",
                     "-d", '{"message":"homebrew search fixture"}', "#{url}/brew-test/_doc/1?refresh=true"
      output = shell_output("curl -fsS --noproxy '*' --max-time 5 '#{url}/brew-test/_search?q=message:homebrew'")
      hit = JSON.parse(output).fetch("hits").fetch("hits").first
      assert_equal "homebrew search fixture", hit.fetch("_source").fetch("message")
    end
  end
end
