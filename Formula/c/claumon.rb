class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "547c2eda386c631e7868cc8f3eda1bb2270cd41db50a631189d3e6705d701537"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"claumon"]
    keep_alive true
    working_dir var
    log_path var/"log/claumon.log"
    error_log_path var/"log/claumon.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claumon version")

    port = free_port
    pid = spawn bin/"claumon", "--port", port.to_s
    sleep 2
    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match(/claumon|dashboard/i, output)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
