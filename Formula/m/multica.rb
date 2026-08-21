class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.32.tar.gz"
  sha256 "6df3792d214231c3a730183945fd1a205d6fee73b29bb2d6f38d01677298510e"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85b2d2469eb636b8ce8ca9205f498c907bf78a318c2dec30c62ca1fee00ce42c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85b2d2469eb636b8ce8ca9205f498c907bf78a318c2dec30c62ca1fee00ce42c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b2d2469eb636b8ce8ca9205f498c907bf78a318c2dec30c62ca1fee00ce42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c44df246d89fad185cb23f89d169c0eba62945f1506f2e8d6967ade6854250e7"
    sha256 cellar: :any,                 x86_64_linux:  "70e748b0bb48abd4ca4bc81348b9a34b4f41b850031075482d49f8d3a84f78ac"
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
