class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "1003ffddd0caa86aab8497077f819771da59c66d5e1d5f5905b1abf117b82038"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18a92669011ae7d1ec23bae41df544e47bc2c45997c0e75e8600e8e1fb75ef49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a92669011ae7d1ec23bae41df544e47bc2c45997c0e75e8600e8e1fb75ef49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edaa675184fe3e86f0735c6f930f079cc9ed7e3202fbe6b2d80e9ac6ce8f3690"
    sha256 cellar: :any,                 x86_64_linux:  "c78d67a0b6b569ddbaf2781d3e5b437049ab3bcacf199ac3b367cd0984e026eb"
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
