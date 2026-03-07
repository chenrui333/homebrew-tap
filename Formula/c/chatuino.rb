class Chatuino < Formula
  desc "Feature-rich TUI Twitch chat client"
  homepage "https://chatuino.net"
  url "https://github.com/julez-dev/chatuino/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a6a232bd47772514bead2fe14da51db588bfd2c45abc943dd6f46c97ec5dbd38"
  license "MIT"
  head "https://github.com/julez-dev/chatuino.git", branch: "main"

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
