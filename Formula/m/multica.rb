class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "c52ffa09412bfc0f6cd6bed0900a66252b1c30f355f257f991a62a88e121eac8"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f64f264870f56cd6ebf38b13b66c1b12f6bfbe2311dd3ef57ce16c030cb1327b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f64f264870f56cd6ebf38b13b66c1b12f6bfbe2311dd3ef57ce16c030cb1327b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc616f9fa4aced9beb2c6fdb7c1cb034c290c53f711d401f91a97df82fa9155a"
    sha256 cellar: :any,                 x86_64_linux:  "302cd3e0f571d41b23984730b046b413f50d4578fd3bc835eb847436f22574a3"
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
