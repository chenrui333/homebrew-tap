class SpaceliftIntent < Formula
  desc "Provision and manage cloud infrastructure using natural language"
  homepage "https://spacelift.io/intent"
  url "https://github.com/spacelift-io/spacelift-intent/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "523f345e29949b61b47683fbf892431cfd83e907a43a6d023a1b32745dce7006"
  license "Apache-2.0"
  head "https://github.com/spacelift-io/spacelift-intent.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/spacelift-intent"
  end

  test do
    require "open3"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = +""
    Open3.popen2e(bin/"spacelift-intent") do |stdin, stdout_err, wait_thr|
      stdin.write json
      stdin.close

      deadline = Time.now + 10
      until output.include?("# Infrastructure Management - Essential Instructions") || Time.now > deadline
        break unless IO.select([stdout_err], nil, nil, 0.5)
        output << stdout_err.readpartial(1024)
      end

      begin
        Process.kill("TERM", wait_thr.pid)
      rescue Errno::ESRCH
      end
    end

    assert_match "# Infrastructure Management - Essential Instructions", output
  end
end
