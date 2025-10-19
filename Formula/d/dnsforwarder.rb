class Dnsforwarder < Formula
  desc "High-performance DNS forwarder with caching and rule-based routing"
  homepage "https://github.com/Kk-ships/dnsforwarder"
  url "https://github.com/Kk-ships/dnsforwarder/archive/05df6909716711d6b8c3c228d6f77c99f5bc4608.tar.gz"
  version "0.0.1"
  sha256 "c9d31f26db8b641ecd50c0ef02bd1dbfbdbd61842ca3bbb7dd853e24ef6f8e93"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/Kk-ships/dnsforwarder.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c620b2be0e5afcd3d40822803cb7bda1efe7bfbdcceea142cc1d384426ee2c77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1ff2a882fc7d864f95bebe8f79b0d068eb2b473d345d22ccc0a8f3ebf4de5f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a762bb8595775f2e07f6bb8ef6da6b9cae924998d97a57a7751a5fa8210b0f06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "324dbedcfbf6b7e29464165bc9aaed349923300ebb4891ec560722d83d555c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69144bb71475127ed167666bfaa1a2b514e4d7d32907f2654df9db164e2a823b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    metrics_port = free_port
    dns_port = free_port

    env = {
      "LOG_LEVEL"                => "warn",
      "ENABLE_METRICS"           => "true",
      "METRICS_PORT"             => ":#{metrics_port}",
      "DNS_PORT"                 => ":#{dns_port}",
      "DNS_STATSLOG"             => "1s",
      "ENABLE_CLIENT_ROUTING"    => "false",
      "ENABLE_DOMAIN_ROUTING"    => "false",
      "ENABLE_CACHE_PERSISTENCE" => "false",
    }

    pid = fork do
      env.each { |k, v| ENV[k] = v }
      exec bin/"dnsforwarder"
    end

    begin
      sleep 1

      assert_match "OK", shell_output("curl -fsS http://127.0.0.1:#{metrics_port}/health")

      metrics = shell_output("curl -s http://127.0.0.1:#{metrics_port}/metrics")
      assert_match "go_info", metrics
      assert_match "dns_cache_size", metrics
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
