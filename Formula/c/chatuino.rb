class Chatuino < Formula
  desc "Feature-rich TUI Twitch chat client"
  homepage "https://chatuino.net"
  url "https://github.com/julez-dev/chatuino/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f2f2ad43978fc6a2da4325eed299b0c80265145fbef2bd94f74deb3396a3bd6d"
  license "MIT"
  head "https://github.com/julez-dev/chatuino.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77886ec762e63ab81cc2967c5a608afb1b49149be4fe3e3e2b31c3238621d742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89b3d7d826b4506cccffef82835bf57642e3ba5bc23c053973b3a44646a96b43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e6fa0bd0aa706ddf3a7fa15f9db740e896b7021265fa89b022a6ee4cfe7fba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bee52d283bfe7361dc43864b0bbf71256fd4f22df2f1e24c736f05416f67f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24e8247675ddce97889e913eeff8356e8ff180d67a28c6d517e62a12cd83f0cc"
  end

  depends_on "go" => :build

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
