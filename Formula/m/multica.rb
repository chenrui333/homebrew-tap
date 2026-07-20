class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "2847ed58025ba034639a436547a83f95113c9ef6ab2163fe73afb2d8cc0b57d5"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d3e9a250d23267cde9791cf29cd91c2b2a58c38f19356da8d25142af6fbe707"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d3e9a250d23267cde9791cf29cd91c2b2a58c38f19356da8d25142af6fbe707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3e9a250d23267cde9791cf29cd91c2b2a58c38f19356da8d25142af6fbe707"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f29ded36733be09535b29f42ee417cd8b1d4291005483004eefbea46d3bc39e"
    sha256 cellar: :any,                 x86_64_linux:  "ea3ed1152fb3c1a17c67b0707551662fd7d2b53c49ce01677a645617c3e40a6f"
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

    system bin/"multica", "config", "set", "server_url", "https://example.com"
    assert_match(%r{^server_url:\s+https://example\.com$}, shell_output("#{bin}/multica config show"))
  end
end
