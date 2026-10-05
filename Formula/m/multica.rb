class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "1c7ec1c28e692f29c53c37dbf083dea431787b80a300073d6d2819c514ac056d"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "001180d5cd3ec0ba6e6d8ef9d58a775375d155150ecc0fe0a2bc811e7c947f97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "001180d5cd3ec0ba6e6d8ef9d58a775375d155150ecc0fe0a2bc811e7c947f97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da5502b85308f0163520f54398e97f3ba1fd50c21598a080796f095296841cdf"
    sha256 cellar: :any,                 x86_64_linux:  "c12408ec12272834b97c1e250e9cfc6bd1a4fa13cec0e3feae3d47c09483fffa"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "server" do
      system "go", "mod", "download"
    end
  end

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

    system bin/"multica", "config", "set", "server_url", "https://example.com"
    assert_match(%r{^server_url:\s+https://example\.com$}, shell_output("#{bin}/multica config show"))
  end
end
