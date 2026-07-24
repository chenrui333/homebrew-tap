class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "fb7f2068716995c835690b73a824246e6b54361668ee5f015d464a19dd983a28"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bc3ab2e4513ed296b31d301a1cf0bc69248dfb2de99ea99e06c50021c9dee9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bc3ab2e4513ed296b31d301a1cf0bc69248dfb2de99ea99e06c50021c9dee9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc3ab2e4513ed296b31d301a1cf0bc69248dfb2de99ea99e06c50021c9dee9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a90f6b9398bb85b505e86bed66be294277ab1da2797d51ff58d71ae6f36acbc6"
    sha256 cellar: :any,                 x86_64_linux:  "6735040d012e764912d82d274aacaf0439998ceb2f41c1ee0b0425cc7b2a0a1b"
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
