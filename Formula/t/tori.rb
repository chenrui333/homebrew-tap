class Tori < Formula
  desc "Remote Docker and host monitoring over SSH"
  homepage "https://toricli.sh/"
  url "https://github.com/thobiasn/tori-cli/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "760e23de7112df41cd1f8d17a2c92ac6593e320d021728627b6895080566647d"
  license "MIT"
  head "https://github.com/thobiasn/tori-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4da8f62daddd836a7ea133f724685c5545a707e637dadd71ecba7f63d081da04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4da8f62daddd836a7ea133f724685c5545a707e637dadd71ecba7f63d081da04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f214b7eb992725c015e8b6b42c7ca1050be641670af5be3904a20dabebd2b3c6"
    sha256 cellar: :any,                 x86_64_linux:  "8232266178503b5b7ce152ed76766392727647a35c87d497a4795afba4753331"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
