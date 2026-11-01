class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "493c126c6e9681ca5fc4beb7816e3943471e9635c2e39a718c9ffd986f9ed9d7"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b88fe32a01b1f740cc4638b9143534e27f136155b00d53212432c758ea6e2f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b88fe32a01b1f740cc4638b9143534e27f136155b00d53212432c758ea6e2f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c2ceb6c7ad98e0115909093969c08972973b6e40765f2cecae9be6cd2374fa"
    sha256 cellar: :any,                 x86_64_linux:  "aa58ec0cc37546c1df413913f98fa014ef6bd2ce8a7ebef1c2fab9b4c855c52d"
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
    assert_match "notaport", shell_output("#{bin}/sish --ssh-address=localhost:notaport 2>&1", 1)
  end
end
