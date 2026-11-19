class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "8a8f2149447dfd0c178fca332f88b539560fa57a5075d67c6e440958de8d49fc"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d324af2f32d95d5399f54ce2f929bbdcc11d47ce0c6caf355da36cac65ab6e52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d324af2f32d95d5399f54ce2f929bbdcc11d47ce0c6caf355da36cac65ab6e52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93dd99dc47bc9344fe0104041f6575144c8b327e4c5fe3c9967bc9b5a1db8ba1"
    sha256 cellar: :any,                 x86_64_linux:  "87558ff6b3300f5549284ea03ac50059a5817f53252be6ac1bdd1c30e5399d98"
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
