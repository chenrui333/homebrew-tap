class Claumon < Formula
  desc "Claude Code dashboard with live rate-limit gauges and usage forecasts"
  homepage "https://github.com/fabioconcina/claumon"
  url "https://github.com/fabioconcina/claumon/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "33d8c466301524571db7bdb6282c6ca78a3767bb2454684e9e2151f34a3d8e8f"
  license "MIT"
  head "https://github.com/fabioconcina/claumon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c89118d7d438ea34a8c74f7b31ad186807df1316642704739a8d778b754033b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c89118d7d438ea34a8c74f7b31ad186807df1316642704739a8d778b754033b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c89118d7d438ea34a8c74f7b31ad186807df1316642704739a8d778b754033b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ffecb691adcd4603cbecc5e1f8bcf2fd60ade6039955d1e7e877979e14653f9"
    sha256 cellar: :any,                 x86_64_linux:  "5dc64ebed8d4a99f65f777cd8512a1733eab4da0a8b970cf3805c4ce8dff865e"
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
