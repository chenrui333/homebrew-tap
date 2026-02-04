class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "c69a7542ad4135cf5f408f533e4767e6a6e8e6ab4cdbd97e3dc004f7dec3b045"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1681189d1f4f4f91982079b691566edf8687ed9ed2ff74abcf8c01471b92686e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1681189d1f4f4f91982079b691566edf8687ed9ed2ff74abcf8c01471b92686e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1681189d1f4f4f91982079b691566edf8687ed9ed2ff74abcf8c01471b92686e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb811190d0121073113523a27a0cb8126f9b137537740dbef16aab213afe9423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb6582f6ab5205578a755291a93216726b93a89ee75d9cdf33acb161a5107739"
  end

  depends_on "go" => :build

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
  end
end
