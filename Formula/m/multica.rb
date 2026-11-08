class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "4d142f4d676f90576dcf71787d3b9d20f6ec5329e0f3a8db14364cdc90253ad2"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5a2cf4f76a50bbb4f85f2626fe4087e35c21b4517a78fd76aa2726acb061d43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a2cf4f76a50bbb4f85f2626fe4087e35c21b4517a78fd76aa2726acb061d43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be6b6905e841234c76bfaee656439cfd07881753e1ca138ed86f2b0096387cb5"
    sha256 cellar: :any,                 x86_64_linux:  "ff194b675824f0831b84309a470186bd0a9cc33d9823fe9632e6c62e14ae3dc7"
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
