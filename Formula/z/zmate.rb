class Zmate < Formula
  desc "Instant terminal sharing; using Zellij"
  homepage "https://github.com/ziinaio/zmate"
  url "https://github.com/ziinaio/zmate/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "bc125bc31fd1550a10b5d62c57a083a0f3fe7d6bc7c21975bf268bfe65a338c2"
  license "MIT"
  head "https://github.com/ziinaio/zmate.git", branch: "main"

  depends_on "go" => :build
  depends_on "zellij"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port

    output_log = testpath/"output.log"
    pid = spawn bin/"zmate", "-l", "127.0.0.0:#{port}", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Skipping remote port-forwarding (local-only mode)", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
