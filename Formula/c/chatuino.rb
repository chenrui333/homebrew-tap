class Chatuino < Formula
  desc "Feature-rich TUI Twitch chat client"
  homepage "https://chatuino.net"
  url "https://github.com/julez-dev/chatuino/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "9678d7e14549ee3f7858214eb49fd4e83cd39fd97e5152fd84eaa237bbcd885e"
  license "MIT"
  head "https://github.com/julez-dev/chatuino.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08ad83bd20f4ba4726ad5a3e47662e38a5679e180def7845dba4669cb90274c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "467753fd88c925bc3f35c62e3644946167823c9e5eddac5f170408ef54326190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6611bec6250e85e3903f6873b0c166d507d4f9800627d31a4008ef284529ef22"
    sha256 cellar: :any,                 x86_64_linux:  "1dab8e630a91b8a40601566d88fa97b7c55beb743cd801bc5a901b0bdbb6eed4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=homebrew
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chatuino version")
    assert_match "GitHub:", shell_output("#{bin}/chatuino contributors")
  end
end
