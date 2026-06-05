class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "fbf741b12f3037dd1307656d1f6ff3be53643882df936c89bcf98f938c9cd29a"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69ef1e33bd363061507b32779b52160e57df13944f621c4a84b1b4bff185a1e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69ef1e33bd363061507b32779b52160e57df13944f621c4a84b1b4bff185a1e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ef1e33bd363061507b32779b52160e57df13944f621c4a84b1b4bff185a1e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0874b07ffdd943b1ffc77aa5922df49aaa4e9fa0f1ca5b2de6674005b96dc4af"
    sha256 cellar: :any,                 x86_64_linux:  "e94c3ca608f263e98f5be52eaca21b9d31d3876233b2593eb18287ad2901e3f4"
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
