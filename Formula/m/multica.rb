class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "1c7ec1c28e692f29c53c37dbf083dea431787b80a300073d6d2819c514ac056d"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c99231d474ced1e2850b0245a2ab990c3149aa154e04adba8ff2bc00da6861fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c99231d474ced1e2850b0245a2ab990c3149aa154e04adba8ff2bc00da6861fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9412f292f4f0d4b2f85efe7ef603d21a4b961629b47b65c891020742353a7b04"
    sha256 cellar: :any,                 x86_64_linux:  "7ba070f46a500f6781afdb26e18a18483f35aa8465c93340fb367925c3ef9169"
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
