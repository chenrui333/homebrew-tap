class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v2.24.1.tar.gz"
  sha256 "d36cd78d38de5f899db2a65d5f935c74712925af1291cf57aa23fefb7e6bdd91"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "613ccfcd60da35c032b2bdfcbfd2b001f362646028bc009939053ecbc3a93fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "613ccfcd60da35c032b2bdfcbfd2b001f362646028bc009939053ecbc3a93fbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3d36746ea015d1601e3eecba37442dbba493a1290bb81400b0130b1e2458e8"
    sha256 cellar: :any,                 x86_64_linux:  "ae589f13c876d9a4fe5744dfbbdaed52de7f3945211ff0c4e943eda488556290"
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
