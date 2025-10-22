class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "e9de07603b03d291c42cb3ee4d33a8a9b2e77b633817396b71e77b19f8730604"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086a684adc9f848b7736f2c3c86c94dd82b62046c1b9a6bbba8b7a63933ee748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "086a684adc9f848b7736f2c3c86c94dd82b62046c1b9a6bbba8b7a63933ee748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "086a684adc9f848b7736f2c3c86c94dd82b62046c1b9a6bbba8b7a63933ee748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8559afa1a3d1831fc0a35dac06711d7f17eda9a775234711e5f207aa43f71b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c313cd929b427ea03e2005c28e2caa13b0b2579f8f7ca8c3c1a2fa562e8213d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/thushan/olla/internal/version.Version=v#{version}
      -X github.com/thushan/olla/internal/version.Commit=#{tap.user}
      -X github.com/thushan/olla/internal/version.Date=#{time.iso8601}
      -X github.com/thushan/olla/internal/version.User=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"olla", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/olla.log"
    error_log_path var/"log/olla.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/olla --version 2>&1")

    port = free_port
    (testpath/"config.yaml").write <<~YAML
      server:
        host: "127.0.0.1"
        port: #{port}
    YAML

    pid = spawn bin/"olla", "serve", "-c", testpath/"config.yaml"

    sleep 1
    begin
      assert_match "healthy", shell_output("curl -s localhost:#{port}/internal/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
