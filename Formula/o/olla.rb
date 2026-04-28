class Olla < Formula
  desc "Lightweight & fast AI inference proxy for self-hosted LLMs backends"
  homepage "https://thushan.github.io/olla/"
  url "https://github.com/thushan/olla/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "8c17611250a74106f398c7b7df68ce63e31d94fad15538a511e034ed7b40193e"
  license "Apache-2.0"
  head "https://github.com/thushan/olla.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a97276f6d2ebd1688d7a929ecc529301d3474ab35e29b5a26c8f172984e4d355"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a97276f6d2ebd1688d7a929ecc529301d3474ab35e29b5a26c8f172984e4d355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a97276f6d2ebd1688d7a929ecc529301d3474ab35e29b5a26c8f172984e4d355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42f2c91ce1ad83c71ef6b2473344eb671e17daef7a0e00123c4f9fe3ee5c7211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b65b508f14dd0bbac803acdd058eeead6f8f700bdf286cd5776570c957393f"
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
