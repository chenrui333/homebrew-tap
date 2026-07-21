class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "702de999de5cd7c648896ea8f75b285fa6ecd1704fa4189d45ca161ac6c28cf2"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "887fadf5c5ab1f5c1e52c5899ce4353199da3ce2af434b2e8a53baa5c12540b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "887fadf5c5ab1f5c1e52c5899ce4353199da3ce2af434b2e8a53baa5c12540b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "887fadf5c5ab1f5c1e52c5899ce4353199da3ce2af434b2e8a53baa5c12540b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca193a9f05128a74c0cd0894e028bab0999ab88304dddaebd774bd8ebf96fd17"
    sha256 cellar: :any,                 x86_64_linux:  "2c8a587e296c8454acd58e83c969ff7b6f770c4142bdb1d3e747717e0ba0af40"
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
