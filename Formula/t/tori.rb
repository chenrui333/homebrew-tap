class Tori < Formula
  desc "Remote Docker and host monitoring over SSH"
  homepage "https://toricli.sh/"
  url "https://github.com/thobiasn/tori-cli/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "2b3116228532ecd68e0bcba728db0fd19f71436ef4e384a3d95648530a5d3c91"
  license "MIT"
  head "https://github.com/thobiasn/tori-cli.git", branch: "main"

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
