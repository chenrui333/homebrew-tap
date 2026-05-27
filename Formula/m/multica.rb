class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "be147b59d9f3202f6ffd632d3163ec41ab55f6ecabe37ddd696311d4609b5a6a"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e886442975e5a87f6b2b2c453810afe7fd2f8f7dc39379672a71ba31c4368a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e886442975e5a87f6b2b2c453810afe7fd2f8f7dc39379672a71ba31c4368a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e886442975e5a87f6b2b2c453810afe7fd2f8f7dc39379672a71ba31c4368a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85cce4fc16cdacf3aaf8ab931cc557f03036d9c0efe2e2f249d36a1e2a314ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b0674fedf695c2bb64c4b6285a2296713e3d93b660278f267e25af3e72a0d6b"
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
