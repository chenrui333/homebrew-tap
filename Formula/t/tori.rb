class Tori < Formula
  desc "Remote Docker and host monitoring over SSH"
  homepage "https://toricli.sh/"
  url "https://github.com/thobiasn/tori-cli/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "2b3116228532ecd68e0bcba728db0fd19f71436ef4e384a3d95648530a5d3c91"
  license "MIT"
  head "https://github.com/thobiasn/tori-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fcc286ed9ea96baed1c80f1e0b2dc573459c5e7adff9d9904a9679831aa9beb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fcc286ed9ea96baed1c80f1e0b2dc573459c5e7adff9d9904a9679831aa9beb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fcc286ed9ea96baed1c80f1e0b2dc573459c5e7adff9d9904a9679831aa9beb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98313758f78181bb5e40cff12ee01d894046c4a08c4a14ae1c30c492a6a800ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3500c81d0f0df166b73b8fd6e10e8bb987a4d50d3e0403345e5c44021985936"
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
