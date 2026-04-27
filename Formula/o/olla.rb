class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "86d15d1f5dd333f49284edf3a0677e57736cbcc2364852621a997801ed4d56cb"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2649c9e1be05a6eda3e2c86cdb5013589796339559bdb47e7547d7826e985d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2649c9e1be05a6eda3e2c86cdb5013589796339559bdb47e7547d7826e985d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2649c9e1be05a6eda3e2c86cdb5013589796339559bdb47e7547d7826e985d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c4d67e2a2e95811ab0b2fe891a08f367c9989f642b7e35c4980e1b4f6777fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2734ddd9bc184a4cc5c1b8bf105dd6e28cfc55e2bb2aadbd1aea0ecc4fd0f9"
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
