class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "8a2e69492f1640b33213105cb3aa0d7e633d77993cdf15d7d847cd54d8859817"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "4f69444def0095522af8b5eaf710c4d4680545efb33c00b559175f0fa977e72f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea42479a1248616874266aac6c2a23e3063fc0c11852297340a77d505ddb1efa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea42479a1248616874266aac6c2a23e3063fc0c11852297340a77d505ddb1efa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1dd499682d52fae922e44455a5d6e79c9855162e83a25ee2269569595d841a5"
    sha256 cellar: :any,                 x86_64_linux:  "563a9bcab1ccb357e5a0d62191879951038f049122c03819eb250b13707c089e"
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
