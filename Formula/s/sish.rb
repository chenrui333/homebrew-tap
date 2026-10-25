class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "b8b8d202b0ff4632ff509baa83d15ba561c797871748de869ee1c536f34f1b3e"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e173e2f8c99dfc38526818511b105ea698797d349c92e06affb2cfeb7053048"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e173e2f8c99dfc38526818511b105ea698797d349c92e06affb2cfeb7053048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e3a510abed7a12b8f40744bab2133764827dc025ae2f5373218c2f9860bb853"
    sha256 cellar: :any,                 x86_64_linux:  "47e18d2be63273e04a5e97470cbe62d77349c6687403f17c90b61b41645e444b"
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
