class Chatuino < Formula
  desc "Feature-rich TUI Twitch chat client"
  homepage "https://chatuino.net"
  url "https://github.com/julez-dev/chatuino/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "b090615c1de8a22c6415cb3210614c0c6d1ad5b99e52ed18c9faac3e13b28408"
  license "MIT"
  head "https://github.com/julez-dev/chatuino.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ea13bb28f3f5a9b9f777689e67d47d633c3d30b40f6f7ac5fd7b8bc5e5ef892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fecc05c7674119864eca6539ec918d2ffe9987c83574629e9962765c1c83c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6751a90d755636ce7746216dcaa59d9ccfe14cddd79b727a2fbad6da150d63d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db5a1079ce167fccd99eafbc983c810cc30b8d35b549ca59b752be87eee5bc7"
    sha256 cellar: :any,                 x86_64_linux:  "1afd79792d213755f4dcfc3b308cf538a60a7ca1ce5941e9f1118c7631dd5f1d"
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
