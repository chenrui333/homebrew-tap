class Tori < Formula
  desc "Remote Docker and host monitoring over SSH"
  homepage "https://toricli.sh/"
  url "https://github.com/thobiasn/tori-cli/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "2aff7df66154fa4558edc3633d28bb4d7dd41d36dcf374028138b961ee243513"
  license "MIT"
  head "https://github.com/thobiasn/tori-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b7afa6fa61f203e6c96ca2d584d85c60a932bd1e3c338b4d7eb791ade1ed7a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b7afa6fa61f203e6c96ca2d584d85c60a932bd1e3c338b4d7eb791ade1ed7a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b7afa6fa61f203e6c96ca2d584d85c60a932bd1e3c338b4d7eb791ade1ed7a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0940727b177952008a11de75f01da66fdcce6cf977e49995b71f704efbda5d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c000ae7ca1a42ebac5c500a2138c3788c5880c1b5d65e853d09efcaada4625c6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tori"
  end

  test do
    output = shell_output("XDG_CONFIG_HOME=#{testpath} #{bin}/tori 2>&1", 1)
    assert_match "No servers configured", output

    socket_output = shell_output("#{bin}/tori --socket #{testpath}/missing.sock 2>&1", 1)
    assert_match "connect:", socket_output
  end
end
