class Chatuino < Formula
  desc "Feature-rich TUI Twitch chat client"
  homepage "https://chatuino.net"
  url "https://github.com/julez-dev/chatuino/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "a06b433f152ca23cfe38cfe52ac744a440bfa6b050be5e4bd9d73ab07e3ebfe5"
  license "MIT"
  head "https://github.com/julez-dev/chatuino.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a157e9b53b40bce6f765555c95ffe1cab3cc937a94e5b52f0252781522180f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1065bd7aae4adf1d55a03b10131b365e6d7cdb8b5b048583298525efb800190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e9576637b27ea4450713fb6bccdcb806c887997f24844c258829eeb812d54df"
    sha256 cellar: :any,                 x86_64_linux:  "73b4deddd5f183a15be9055643c9733d5d79597c41a86f0f12e53d7b99504cd0"
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
