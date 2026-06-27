class Tori < Formula
  desc "Remote Docker and host monitoring over SSH"
  homepage "https://toricli.sh/"
  url "https://github.com/thobiasn/tori-cli/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "760e23de7112df41cd1f8d17a2c92ac6593e320d021728627b6895080566647d"
  license "MIT"
  head "https://github.com/thobiasn/tori-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79d2effebb17133d3facc47bec517459b2fc53561f101ad56cee74f75fa1309f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d2effebb17133d3facc47bec517459b2fc53561f101ad56cee74f75fa1309f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d2effebb17133d3facc47bec517459b2fc53561f101ad56cee74f75fa1309f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71dab7f4c7bc1d97d03185ef8073aab3142e491fbbc110251270970108751b4f"
    sha256 cellar: :any,                 x86_64_linux:  "92f7021e82e502509f3b63c61a59c40a5edaa7da1bf789c959bdb03ddf2e0399"
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
