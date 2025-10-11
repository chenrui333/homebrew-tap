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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c697c392a9e5d0a2c4a0815139c8f64a160ab5e327b88e24835dac230fda13f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "687cc7764e7cd9c7cff08a66e542ff97925f698b730dc892b932d28e9b387ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f58b0de99b558f47d0ddd065b7785bc38ecf4b4e6b51b42534fdcbfcb21fc47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f3cb70d4a39506a8bb13fae91fbfa062030a56e5a1265c6cd3e9caece435fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ccdf796d161771b9c8c2e5b208ed18186c43f2ed2e16ba279f54ac8888e6a7"
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
