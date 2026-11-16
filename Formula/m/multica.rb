class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4f0092e840fc07014b80b5a7fa9bf11e96425a4dd1879e86485df8511b7be999"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c954695376e2352f85c8e1889a204e61def349cd6dea3e032a5a4e4cae3cf7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c954695376e2352f85c8e1889a204e61def349cd6dea3e032a5a4e4cae3cf7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e726433c726ee37c968e17ad51abf6576d62cafc42bdbc671dee511ebb0bfa64"
    sha256 cellar: :any,                 x86_64_linux:  "447d4985e38c474096fbf1b8f2b81f7ad6c0118f1a6155bed0726333ea9ee14a"
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
