class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.34.tar.gz"
  sha256 "b22a89134f0fe5609d5066728850c7240c10e0c3e523896329cc74cbdb55ada4"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89415627b0fd4f0c74994361cc0a426e990ca41d22e4c0ee793ec9686442ef0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89415627b0fd4f0c74994361cc0a426e990ca41d22e4c0ee793ec9686442ef0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89415627b0fd4f0c74994361cc0a426e990ca41d22e4c0ee793ec9686442ef0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9718a1e09c5ac18b89d623ff482c19f23f9f6037ca4a2fcb2409137df3a36bec"
    sha256 cellar: :any,                 x86_64_linux:  "a50da3213fedcf3e2b7a23d94fafb0ef29febd6fb6d693629e4f27406ac96a50"
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
