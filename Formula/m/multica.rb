class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "1003ffddd0caa86aab8497077f819771da59c66d5e1d5f5905b1abf117b82038"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba89f740f28a484fe9f2e1ae0dc7366bcee3b0bf6dac3cf7dbefafcde2d2fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aba89f740f28a484fe9f2e1ae0dc7366bcee3b0bf6dac3cf7dbefafcde2d2fbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22d30b97f9df40f7e8a53c51e4bfbce55ca41a0f192ce642f8b95ed178d1f398"
    sha256 cellar: :any,                 x86_64_linux:  "af7bf1e7b00a0eff7b12113c8588ecac44d796e08f3caa80f1f5da35bb2eee76"
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
