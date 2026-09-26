class Zmate < Formula
  desc "Instant terminal sharing; using Zellij"
  homepage "https://github.com/ziinaio/zmate"
  url "https://github.com/ziinaio/zmate/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "53080085e9e08c3b2407e99db39358f42d0d44fd1f80997959c28f9d35283dd8"
  license "MIT"
  head "https://github.com/ziinaio/zmate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c174ea6995a4756db280a4cc497c0a7d313c6a95ab0095f69ae1bd93c8c41ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c174ea6995a4756db280a4cc497c0a7d313c6a95ab0095f69ae1bd93c8c41ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "886ff1082158084a43a5aee3c863f610175998717de54362550e0413ccb50f9d"
    sha256 cellar: :any,                 x86_64_linux:  "f972c2b515c88fa7e4fa65e12e0a83b3b9d7bbba42d93d7cdb6ae0d5e46b975f"
  end

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
