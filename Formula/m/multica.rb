class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.22.tar.gz"
  sha256 "fe27bcbe2129e8d646195768fca5420c7a2e69f9013af7f80f66a90c0a4b4867"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a5a3ecfc6b780628a2afe4073510d50a06e8041e97cf8a378ab0fdaf1f57f44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a5a3ecfc6b780628a2afe4073510d50a06e8041e97cf8a378ab0fdaf1f57f44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a5a3ecfc6b780628a2afe4073510d50a06e8041e97cf8a378ab0fdaf1f57f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "815c6bfd4a0dc092d56ac15e22f69c8b0609375034f914d3988199eb6349d411"
    sha256 cellar: :any,                 x86_64_linux:  "419ddabec7df9858e7c5298cb0075f43900d9ce18a8838e66f10926f4f928a0b"
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
