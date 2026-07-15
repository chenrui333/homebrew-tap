class Oproxy < Formula
  desc "Open-source MITM proxy to intercept, inspect, and mock network traffic"
  homepage "https://github.com/sauravrao637/oproxy"
  url "https://github.com/sauravrao637/oproxy/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "4adb1c55a0bd8cba01686b33036db2eccf4b3985636a5e8222d52ba74dbda042"
  license "MIT"
  head "https://github.com/sauravrao637/oproxy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df4f0f38c7cfcd2000f4ead8e4c04d27cba571053629ef45627ea37c6f78ce46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00a3a67e654b4c806e8024e96f067cc600c5b79dcbd70f96de138c8905ed5a70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6d773c533257638acaf8ed9c4042ea0964c95e6762778f8de9713a167cc160"
    sha256 cellar: :any,                 arm64_linux:   "e7a125f884e64b487b193b5fa0a7c15fc061e07e3327839cbf3cb9a0e2623767"
    sha256 cellar: :any,                 x86_64_linux:  "5a6b409ccb6fe66210f0321e9dd643598f137979d682dc5d95c9c835e9e43414"
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
