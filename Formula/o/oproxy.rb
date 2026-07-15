class Oproxy < Formula
  desc "Open-source MITM proxy to intercept, inspect, and mock network traffic"
  homepage "https://github.com/sauravrao637/oproxy"
  url "https://github.com/sauravrao637/oproxy/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "4adb1c55a0bd8cba01686b33036db2eccf4b3985636a5e8222d52ba74dbda042"
  license "MIT"
  head "https://github.com/sauravrao637/oproxy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "468295a224d7fd5428411c5084ba08b997316499f3743a454a094eecf7ecf137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71e41a6b9ae8877743023f7c833de5cbae693921265fbd401401db4fd0cce704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "563a2c289e28a370eb18e7cc4e8e85030eed659dd1fdf985dab0d22b069f7962"
    sha256 cellar: :any,                 arm64_linux:   "dd3ac4f5b0fb0255584290ddd886c614ff13391d0cf92b51111ad1771221d945"
    sha256 cellar: :any,                 x86_64_linux:  "1b1d3434ab7f3ec4efa1be03ceaf04d8065166b8e6bb61180bae3f23fb9d5ae8"
  end

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
