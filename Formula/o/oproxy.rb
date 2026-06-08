class Oproxy < Formula
  desc "Open-source MITM proxy to intercept, inspect, and mock network traffic"
  homepage "https://github.com/sauravrao637/oproxy"
  url "https://github.com/sauravrao637/oproxy/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "0282e6ad610367f8b70d17478648a8c295591292e4c86c5160bcb538100a89de"
  license "MIT"
  head "https://github.com/sauravrao637/oproxy.git", branch: "main"

  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    cd "src/design" do
      system "npm", "install", *std_npm_args(prefix: false, ignore_scripts: false)
      system "node", "build.mjs"
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    config = testpath/"config.yaml"
    config.write <<~YAML
      port: #{port}
      mitm:
        enabled: false
        root_ca_path: #{testpath}/certs
      storage_path: #{testpath}/storage
    YAML

    ENV["OPROXY_CONFIG"] = config.to_s

    pid = spawn bin/"oproxy"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/health")
    assert_match '"status":"ok"', output
    assert_path_exists testpath/"certs/root.crt"
  ensure
    Process.kill("TERM", pid) if pid
  end
end
