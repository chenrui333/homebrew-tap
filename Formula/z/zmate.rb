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

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # The test sandbox blocks listening and dialing, so exercise the offline startup path:
    # listen-address validation, SSH host key generation and the missing SSH agent error.
    output = shell_output("#{bin}/zmate --listen 127.0.0.1:2222 2>&1", 1)
    assert_match "address for remote ssh server not provided", output

    ENV.delete "SSH_AUTH_SOCK"
    host_key = testpath/"ssh_host_ed25519_key"
    output = shell_output("#{bin}/zmate --listen 127.0.0.1:2222 --server 127.0.0.1:2222 " \
                          "--host-key #{host_key} 2>&1", 1)
    assert_match "SSH agent not found: ensure SSH_AUTH_SOCK is set", output
    assert_match "BEGIN PRIVATE KEY", host_key.read
  end
end
