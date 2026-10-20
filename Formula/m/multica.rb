class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "2b3492beab03c4282431ca44e90575d2eef66e312325a381a2dbf74242acf294"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b59e560bfb4e1011c5de1b4b5736796db32de0d35b4ab53949eb4525d3ca4fd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b59e560bfb4e1011c5de1b4b5736796db32de0d35b4ab53949eb4525d3ca4fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7645a91482f962fd161eb9ede2e332b06e6fda6a7393334dcb4d50174004a60"
    sha256 cellar: :any,                 x86_64_linux:  "8dd0074eec8885de2e65d95eb0cf1d49bae4bebc393b5f14038a550ff5bb23df"
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
