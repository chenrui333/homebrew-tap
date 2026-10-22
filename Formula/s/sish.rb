class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "acae8bafa2b88c8bc64e038b82981bf7699af18a720aca68cbd6e23aac23ff7d"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cd39b6aab44cd840ad9b34c76ad710ac3080456215ffddc99d9677ac28c2d35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cd39b6aab44cd840ad9b34c76ad710ac3080456215ffddc99d9677ac28c2d35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "700031da134f47f89f96e1f6b54fecb20fc13e3c76d92012c50e4f3982a2a7fc"
    sha256 cellar: :any,                 x86_64_linux:  "5c2cf43898b1b41caeb21ed70eefa2a63b88e4871cab4cd9dff59986c29a91ee"
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
