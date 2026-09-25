class Oproxy < Formula
  desc "Open-source MITM proxy to intercept, inspect, and mock network traffic"
  homepage "https://github.com/sauravrao637/oproxy"
  url "https://github.com/sauravrao637/oproxy/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "125fdd9b50540ceed5195d827b7b32d6293c0084bdcd1546b24129604111fcd6"
  license "MIT"
  head "https://github.com/sauravrao637/oproxy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10bd87ad3323bd3e07e3464075e28c9de30b4cd850adda35b65858e8968f141d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf3c7ffcbe965e05229b90fbc60872066addd9d9af8bfce719306c7283742f4"
    sha256 cellar: :any,                 arm64_linux:   "e8224376079eaf7b9d8062c4d61ad285adc5799ae4b127beb243487031d14e2e"
    sha256 cellar: :any,                 x86_64_linux:  "7841e7650fb3560c565fb1809fb73fa19ea6dd208c52c92983d57641db841eea"
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

  service do
    run [opt_bin/"oproxy"]
    keep_alive true
    working_dir var/"oproxy"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
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
