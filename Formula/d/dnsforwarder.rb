class Dnsforwarder < Formula
  desc "High-performance DNS forwarder with caching and rule-based routing"
  homepage "https://github.com/Kk-ships/dnsforwarder"
  url "https://github.com/Kk-ships/dnsforwarder/archive/05df6909716711d6b8c3c228d6f77c99f5bc4608.tar.gz"
  version "0.0.1"
  sha256 "c9d31f26db8b641ecd50c0ef02bd1dbfbdbd61842ca3bbb7dd853e24ef6f8e93"
  license "GPL-3.0-or-later"
  head "https://github.com/Kk-ships/dnsforwarder.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b38c839f46e92e303d31d579d2da39c0ac766c98780641b46b73bd63d15136c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aa0f88da49f8afa4807a1001c2b7a53f938dd62f9a82812653eeb6c4029f316"
    sha256 cellar: :any_skip_relocation, ventura:       "30cbc2b131c5e1c2e36df23bd7e2525e3e0d19c422ff5b56d7cca108a26efab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c3996b22df31abe8aa574a19d000ee0730e04b8339ae30c958570446996bb34"
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
