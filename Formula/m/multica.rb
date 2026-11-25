class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "8a2e69492f1640b33213105cb3aa0d7e633d77993cdf15d7d847cd54d8859817"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb6bcfe039d138bdd97db73c4a8851dff9722bd9564290bb2f8a81322893bae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abb6bcfe039d138bdd97db73c4a8851dff9722bd9564290bb2f8a81322893bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b59767e6e2705876955c1f9775dcd4f57d7d1f79923688a1cfdcdbd6d8b4033f"
    sha256 cellar: :any,                 x86_64_linux:  "786929b31a7873d395436ee346b725548d96f0971f54702e05a3d88545640708"
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
