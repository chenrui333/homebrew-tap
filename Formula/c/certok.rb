class Certok < Formula
  desc "CLI to check the validity and expiration dates of SSL certificates"
  homepage "https://github.com/genuinetools/certok"
  url "https://github.com/genuinetools/certok/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "e874b7a04781ca5b056a53f3a7082ab91bd68e3841789e6d9aeab90ac5976149"
  license "MIT"
  revision 1

  livecheck do
    skip "no recent releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59fde6f8fffad3f331c81019b8ef8d0bf2945a6706ca3c0f1f204540d8b1eeb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59fde6f8fffad3f331c81019b8ef8d0bf2945a6706ca3c0f1f204540d8b1eeb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59fde6f8fffad3f331c81019b8ef8d0bf2945a6706ca3c0f1f204540d8b1eeb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "def542c49a33ceb650de99785b7915b5e83bb94ae94a3b13ae1d0377716563b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184855e4fce0323c959323430da6f424d4bb8655d86509e924d58eb2a31f9a47"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/genuinetools/certok/version.VERSION=#{version}
      -X github.com/genuinetools/certok/version.GITCOMMIT=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/certok version")

    hosts_file = testpath/"hosts.txt"
    hosts_file.write("example.com")
    output = shell_output("#{bin}/certok #{hosts_file}")
    assert_match "DigiCert Global G3 TLS ECC SHA384 2020 CA1  ECDSA-SHA384", output
  end
end
