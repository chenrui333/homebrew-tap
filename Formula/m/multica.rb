class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "182635dabd4e4b6a3ef698be8b5615931c686f63ab846d5d6807d312e0758653"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9297bc9e354fb13fe3fc273e0cc57bea689e4ada10e801f0249c2f14267e9059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9297bc9e354fb13fe3fc273e0cc57bea689e4ada10e801f0249c2f14267e9059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9297bc9e354fb13fe3fc273e0cc57bea689e4ada10e801f0249c2f14267e9059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f8bc57991f910590b93a85a5445d335a231b9fdd6c82d02cdd65de87ebba5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74465169f4a7b43a7b433a1fc5d63dcc15e5af2f54630d3a6f180db410cb9ecb"
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
