class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.39.tar.gz"
  sha256 "347e02185450ee9582fe878e4338735d8b9d1c728b4209b12ba4a5df9ee36c2a"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "414f4f5933a994d3e7243902fc2d00f3cb859bdf45844aaaa90b7aec1726ab6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "414f4f5933a994d3e7243902fc2d00f3cb859bdf45844aaaa90b7aec1726ab6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414f4f5933a994d3e7243902fc2d00f3cb859bdf45844aaaa90b7aec1726ab6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f06db8d923d9099e0f767a220a744b2fa6b95515308aa0bd480d976b14521432"
    sha256 cellar: :any,                 x86_64_linux:  "234e14093d3fa2b88d9c3afa84f72596dc4220901d93d68b6a000c1b6a4e1f88"
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
