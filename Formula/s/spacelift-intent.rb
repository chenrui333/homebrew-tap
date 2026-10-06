class SpaceliftIntent < Formula
  desc "Provision and manage cloud infrastructure using natural language"
  homepage "https://spacelift.io/intent"
  url "https://github.com/spacelift-io/spacelift-intent/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4562ea20d2a2234890127b6ba235c07cefcfac6dbbe743defd1234f2cd89bc9f"
  license "Apache-2.0"
  head "https://github.com/spacelift-io/spacelift-intent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "604a4ba8e6342654d4eb724e40d9b0ce645ad78a96243ebb1e948ac6786cb0f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6acca04445d43ea3078e6f9c8f95db7914c8839e6a877785d426d510f8942aa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d84e403cccc9ecf0cab181b620559c934fa336c1fc8b55fff913ed9e3683ebd"
    sha256 cellar: :any,                 x86_64_linux:  "976d4d446f22070ecb1a51d3fe5947d1c9e219bb252572bf0536cf499a0e0aa1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/spacelift-intent"
  end

  test do
    require "json"
    require "open3"

    messages = [
      {
        jsonrpc: "2.0",
        id:      1,
        method:  "initialize",
        params:  {
          protocolVersion: "2025-03-26",
          capabilities:    {},
          clientInfo:      {
            name:    "brew-test",
            version: "1.0",
          },
        },
      },
      {
        jsonrpc: "2.0",
        method:  "notifications/initialized",
        params:  {},
      },
      {
        jsonrpc: "2.0",
        id:      2,
        method:  "tools/list",
        params:  {},
      },
    ]

    output = +""
    Open3.popen2e(bin/"spacelift-intent") do |stdin, stdout_err, wait_thread|
      messages.each { |message| stdin.puts JSON.generate(message) }
      stdin.flush

      deadline = Time.now + 10
      until output.include?("# Infrastructure Management - Essential Instructions") || Time.now > deadline
        next unless stdout_err.wait_readable(0.5)

        begin
          output << stdout_err.readpartial(4096)
        rescue EOFError
          break
        end
      end

      stdin.close unless stdin.closed?
      if wait_thread.alive?
        begin
          Process.kill("TERM", wait_thread.pid)
        rescue Errno::ESRCH
          nil
        end
        wait_thread.join
      end
    end

    assert_match "# Infrastructure Management - Essential Instructions", output
  end
end
