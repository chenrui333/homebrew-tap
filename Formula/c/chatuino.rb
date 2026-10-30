class Chatuino < Formula
  desc "Feature-rich TUI Twitch chat client"
  homepage "https://chatuino.net"
  url "https://github.com/julez-dev/chatuino/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "9678d7e14549ee3f7858214eb49fd4e83cd39fd97e5152fd84eaa237bbcd885e"
  license "MIT"
  head "https://github.com/julez-dev/chatuino.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4c50ebc3f0d5a24b5a3c226fcff1e4b2dd4119836325c05cf1d6bc3ee504ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0187afe3bb78ccd64a0824dd797f7d93b2a9abefe77ba358631e19a3add0aac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c42ea22d4df30b0886f1b445fa7cdc95302ba608d7695c3615f05aff1d457130"
    sha256 cellar: :any,                 x86_64_linux:  "e3b0d928fa08b3121587560ab014af25256b3493fe3e60d140ce2754bf405212"
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
