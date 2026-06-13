class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "547c2eda386c631e7868cc8f3eda1bb2270cd41db50a631189d3e6705d701537"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40dbbb58d09b52227124b0f8ef0d0cba2481b6679c53516b4d971d8c9a81e63c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40dbbb58d09b52227124b0f8ef0d0cba2481b6679c53516b4d971d8c9a81e63c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40dbbb58d09b52227124b0f8ef0d0cba2481b6679c53516b4d971d8c9a81e63c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e60670756a3869124f5f21e774074b7cd23b6072857185127c8c5aca72df4c"
    sha256 cellar: :any,                 x86_64_linux:  "f18cc7bfca5a93936c545274b7d9d01fa98bb4b2072ec8c0df3f5be8a35a239a"
  end

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
