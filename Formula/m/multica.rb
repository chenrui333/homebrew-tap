class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "bd4c86ab01c56b42c8483d548e6b2484d70fbe9f36de6092c840b81d6cb4664a"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0371b9736831232d1844082228b05d0bb9e1b040d8d3e69d39b662e98c2f402c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0371b9736831232d1844082228b05d0bb9e1b040d8d3e69d39b662e98c2f402c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0371b9736831232d1844082228b05d0bb9e1b040d8d3e69d39b662e98c2f402c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f15edbcc9beb9cfc82488f489dc0335535d256acd3eea46b35181e3f0baad714"
    sha256 cellar: :any,                 x86_64_linux:  "ae15b76d57274bfe7bd19fdc77c491bbab3bc11b3443f30bc17c0f5490e0200b"
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
    assert_match "server_url:   https://example.com", shell_output("#{bin}/multica config show")
  end
end
