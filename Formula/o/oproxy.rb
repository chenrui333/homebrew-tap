class Oproxy < Formula
  desc "Open-source MITM proxy to intercept, inspect, and mock network traffic"
  homepage "https://github.com/sauravrao637/oproxy"
  url "https://github.com/sauravrao637/oproxy/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "125fdd9b50540ceed5195d827b7b32d6293c0084bdcd1546b24129604111fcd6"
  license "MIT"
  head "https://github.com/sauravrao637/oproxy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ded0fdc013fa65b4566bbfb303d27f938105bc78c8e2b0985195e6134c783f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6db2d5a8d00dd5fb7489d1b83a9575e48cf11390b7c5d5c001d663f4151cb90"
    sha256 cellar: :any,                 arm64_linux:   "d6318308bbba9b482a366cc8f404a32ec21566ec6f6dd88ee331baa1f82f05e6"
    sha256 cellar: :any,                 x86_64_linux:  "92da1e6dd51184278a6a6782692875c238c449aab5e3326175a0fe64045dfc0e"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  # The test checks the proxy's /health endpoint over a loopback HTTP socket.
  allow_network_access! :test

  def fetch
    cd "src/design" do
      system "npm", "install", *std_npm_args(prefix: false, ignore_scripts: false)
    end
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    cd "src/design" do
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
