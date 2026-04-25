class SpaceliftIntent < Formula
  desc "Provision and manage cloud infrastructure using natural language"
  homepage "https://spacelift.io/intent"
  url "https://github.com/spacelift-io/spacelift-intent/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4562ea20d2a2234890127b6ba235c07cefcfac6dbbe743defd1234f2cd89bc9f"
  license "Apache-2.0"
  head "https://github.com/spacelift-io/spacelift-intent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d483c1cb92f28258fb69416b20cf8db6c223ec89b4aaf98ca8ae1d5b4854296"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f15cc72c2d01c6c993aea72bcd46119b811e5dfbefe4874279d6a6c3574afc95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5135ecd0a552fcc733e88eecad0e5bb7c33a5b1e31c76753281664df8bd7fad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599f60214b069a217fe0e846b3e37a794cde9a0e5f3bca629022be8ee8e51ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcd230e4f2eb791ef2c832ef947589fa9be371d8a5e6452d4bd8e473ba6de828"
  end

  depends_on "go" => :build

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
