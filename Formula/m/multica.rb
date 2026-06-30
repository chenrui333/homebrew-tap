class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.33.tar.gz"
  sha256 "d2d28e0565f9b1a70abbb6891d146f2b729e52216823edf8e8b072891e11d388"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c31340f85f8bde9178d1a037275c9dc09ca340ad9e4595e3826bcbdee846d071"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c31340f85f8bde9178d1a037275c9dc09ca340ad9e4595e3826bcbdee846d071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c31340f85f8bde9178d1a037275c9dc09ca340ad9e4595e3826bcbdee846d071"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f703ea7ade4541121668b8e6b54a9cda20ebf605f971edf2dc8bce7c96508d3a"
    sha256 cellar: :any,                 x86_64_linux:  "765b69be227d6ea8696ef5c7847c8dae4927643b58459d0f8832df382ec79f05"
  end

  depends_on "go" => :build

  def install
    cd "server" do
      ldflags = %W[
        -s -w
        -X main.version=#{version}
        -X main.commit=#{tap.user}
        -X main.date=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cmd/multica"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multica version")
  end
end
