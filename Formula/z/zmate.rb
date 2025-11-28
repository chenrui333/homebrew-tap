class Zmate < Formula
  desc "Instant terminal sharing; using Zellij"
  homepage "https://github.com/ziinaio/zmate"
  url "https://github.com/ziinaio/zmate/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "bc125bc31fd1550a10b5d62c57a083a0f3fe7d6bc7c21975bf268bfe65a338c2"
  license "MIT"
  head "https://github.com/ziinaio/zmate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60ab2d3ba264b8de3abe00e7a746c22f7df0665b6311875c8d64a179deff5e6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60ab2d3ba264b8de3abe00e7a746c22f7df0665b6311875c8d64a179deff5e6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60ab2d3ba264b8de3abe00e7a746c22f7df0665b6311875c8d64a179deff5e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e785393b4db980c52ccaf231119e49e65e6548e2c13453d63d69ac82ef75dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8343429ea575feed0dc35e06f583cc1b909f6a23bd05c5ba937df9ce284f9bc4"
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
