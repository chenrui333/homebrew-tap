class Chatuino < Formula
  desc "Feature-rich TUI Twitch chat client"
  homepage "https://chatuino.net"
  url "https://github.com/julez-dev/chatuino/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f2f2ad43978fc6a2da4325eed299b0c80265145fbef2bd94f74deb3396a3bd6d"
  license "MIT"
  head "https://github.com/julez-dev/chatuino.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65b8e69849cd6fa9fd2c089f661e80d319aadd502175102f197be062db6c94eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dadbadb02645506e61c213f943e9955723fa95135d6570b760b3e9e710d5c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f924b18108372a7bc65a363ff83b5a8479efe399c51c2a3707d3da5b22fa321e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c4bd1ef1767ff6236df9fc93d965da7b4963eab5c2164e4beb4e8b553933f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98620ee77702200d33c33aee17f604c0c771dfbb03eaa0a685c1616141102190"
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
