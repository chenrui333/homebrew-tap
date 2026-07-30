class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "5561df7e363891738253361e9240f06992852a5ceb89338d682fd18625829c3d"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5ab844df65d90f093d39c272a08d43d69ea04646e1ddbaa668646ee74d18c5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ab844df65d90f093d39c272a08d43d69ea04646e1ddbaa668646ee74d18c5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ab844df65d90f093d39c272a08d43d69ea04646e1ddbaa668646ee74d18c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00d1d23414c57be4f36719ac00f862c90d95605bffeb84f483244d041cc49d9d"
    sha256 cellar: :any,                 x86_64_linux:  "cd40682244b3b8f3c33feb62cc4bc2df32451b4e2f621533dea56c062fa16580"
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
