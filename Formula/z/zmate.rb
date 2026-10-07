class Zmate < Formula
  desc "Instant terminal sharing; using Zellij"
  homepage "https://github.com/ziinaio/zmate"
  url "https://github.com/ziinaio/zmate/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "53080085e9e08c3b2407e99db39358f42d0d44fd1f80997959c28f9d35283dd8"
  license "MIT"
  head "https://github.com/ziinaio/zmate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec3c938630a308d4d786cd38977f322ae6f13fe2766adb3ee97a9a0f813fa52d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec3c938630a308d4d786cd38977f322ae6f13fe2766adb3ee97a9a0f813fa52d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c2302a84d4bf935fe5ef8fe7b0081f4e87ff0d62a99053bbe2549d6ff992696"
    sha256 cellar: :any,                 x86_64_linux:  "eee4c340481cee4d76db23c522e277a0324d48fc73fab2d834f1878f8af432a5"
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
