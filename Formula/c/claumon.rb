class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "e7ed16c042616a1f2dabec259616d8cf4b6071b87efa368a6d6e0795d69217cf"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76b88ec8f90e9e8425d122f2de21241ce4f22397ec48aa3a12a1f3423126c36a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b88ec8f90e9e8425d122f2de21241ce4f22397ec48aa3a12a1f3423126c36a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b88ec8f90e9e8425d122f2de21241ce4f22397ec48aa3a12a1f3423126c36a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "805a5f9814b90c5e3c2d5872b38b7eef9e609c7352a4669cafee1ac97179ee12"
    sha256 cellar: :any,                 x86_64_linux:  "ad97dd1e27aa335759587141fc761145d2b458a8871e4a43dff20c9be673178f"
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
