class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "eb05fb841319cfa93bd5d441c18e2a21fbd97bba08f0562e185c58f1b174dcfd"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "442f62089e99d86b1922d22ad39cda2afba6c488894112edfb43a0658690bf95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "442f62089e99d86b1922d22ad39cda2afba6c488894112edfb43a0658690bf95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e957868708e0188a3a81f31e11acb61c8431cf328d24c9ce176ef4210f70c0e2"
    sha256 cellar: :any,                 x86_64_linux:  "2cba735b1f623b5069ada22efdb806c0cad2fb076c1b2fb0b3eb315e3ed4bf1e"
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
