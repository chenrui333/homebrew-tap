class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "2b3492beab03c4282431ca44e90575d2eef66e312325a381a2dbf74242acf294"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb15e243e8a7a6d7023051b9a27c31d389f8086fe0d3ce67be2b05c164d64fe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb15e243e8a7a6d7023051b9a27c31d389f8086fe0d3ce67be2b05c164d64fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4852cf19f834124a8954c99f54d36b6590941590843e20cf2df1f4b51a45c6f"
    sha256 cellar: :any,                 x86_64_linux:  "84a5be6ef52e7e2dcc3c719f467b82ea7c02f217f65884410cd73d32b4f254bb"
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
