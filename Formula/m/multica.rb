class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.31.tar.gz"
  sha256 "661d56c822f4018d3d53f0018a522a79fe1e33a0c4ed2242248a55e67f940806"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e72d229ac9073332756d742e2554eccb77ac4d6e90b96be9b5ad0ea563897a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e72d229ac9073332756d742e2554eccb77ac4d6e90b96be9b5ad0ea563897a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e72d229ac9073332756d742e2554eccb77ac4d6e90b96be9b5ad0ea563897a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d9f2798e9cd13521dd0f30844a8a4898c8d70ace53586ecb47d5594616c81b"
    sha256 cellar: :any,                 x86_64_linux:  "6197a8f07a915a38cc509ee664e5a1cb90ec859e77efcb7ca7725f80fe30e36d"
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
