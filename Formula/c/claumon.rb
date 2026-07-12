class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "33d8c466301524571db7bdb6282c6ca78a3767bb2454684e9e2151f34a3d8e8f"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a69a47859d96dee6fdbb40ccc59fcb16128df43732fe15dff2a98e6b29eef7a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a69a47859d96dee6fdbb40ccc59fcb16128df43732fe15dff2a98e6b29eef7a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a69a47859d96dee6fdbb40ccc59fcb16128df43732fe15dff2a98e6b29eef7a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36b99641bbd6e30ed28d2f5c44e21dd157451395e642586984e39faa223f3e8"
    sha256 cellar: :any,                 x86_64_linux:  "1d51877af93022cdfbb11289ec3b245c7e6ff2336408fc6f2521052b5ee99771"
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
