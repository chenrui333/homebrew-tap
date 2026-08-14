class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.26.tar.gz"
  sha256 "4ce388aac93b611c26780b8d65877d4735383841a7e94bbc96eb62af1fdbf499"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4d101973bf7009ad6f9c9182e8611f608e9ea334cf8c6b2e014bfa4bb298d8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4d101973bf7009ad6f9c9182e8611f608e9ea334cf8c6b2e014bfa4bb298d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4d101973bf7009ad6f9c9182e8611f608e9ea334cf8c6b2e014bfa4bb298d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e496b229730d1c0995fc6956ffb6c08bc2254041e5577d026900486b7fa01d9d"
    sha256 cellar: :any,                 x86_64_linux:  "aa1659310abbeba143cefd145201eb3a83b2828046d3ab4be429cee755a0be60"
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
