class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "7a3cda70e665adbcc2f8461e9cdc58177df93a99b4c8bb7f56d0687fe7e8b478"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "264e6b591adffbe5525fca504ad44e87ed60945215e6a38e37d60361cb017707"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "264e6b591adffbe5525fca504ad44e87ed60945215e6a38e37d60361cb017707"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041b9e10a93dd5abcebde6c2f51d88041c74a95e3734d1f30077f46d79eca9e5"
    sha256 cellar: :any,                 x86_64_linux:  "9773d212f32c67c304ae62bfa2ffbfebc9ada91adfbfbce0017d4aafc63f01d1"
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
