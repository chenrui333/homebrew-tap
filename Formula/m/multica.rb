class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "20681e8d5e085ceb6672234906ca453967cbec0d109a5b2f9342bd7308a39f34"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c441230f6d7db6225ef4ee724beca81e456c7fa799f483547ddbd7b96d5e0faf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c441230f6d7db6225ef4ee724beca81e456c7fa799f483547ddbd7b96d5e0faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f90c7162d38b035c7787475394f17e57bec31fb3b8dedb11904fc1915866063f"
    sha256 cellar: :any,                 x86_64_linux:  "4393323f6ddc6e76b6448eadf3a9c143bb4d2727bcd28606498c93d291c27b9b"
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
