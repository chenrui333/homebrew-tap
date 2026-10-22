class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "787882739305d4c97042dbbd2200737ffb314173e22389bb297ad31c710ea6bc"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8171c62e4b76aba2363225351ca1a26766df463ebd5ee5f7b2a2af316d29249b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8171c62e4b76aba2363225351ca1a26766df463ebd5ee5f7b2a2af316d29249b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce224dccf6c8434e43fe6c117e749c159fa27e220f59981155b81d3f40e90845"
    sha256 cellar: :any,                 x86_64_linux:  "64bf0f14665dc637d658920583dc2d9ac029e034f7e19407e343cb365fd29491"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/antoniomika/sish/cmd.Version=#{version}
      -X github.com/antoniomika/sish/cmd.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sish --version")

    # Listener addresses are validated before any SSH/HTTP listener is opened
    output = shell_output("#{bin}/sish --ssh-address=localhost:notaport 2>&1", 1)
    assert_match "Error parsing address", output
  end
end
