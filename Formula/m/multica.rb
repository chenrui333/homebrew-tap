class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "fb7f2068716995c835690b73a824246e6b54361668ee5f015d464a19dd983a28"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d57119b8d5f9be848259d894d2d3fa00d36611763ba18770cc14b98b20a8afcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d57119b8d5f9be848259d894d2d3fa00d36611763ba18770cc14b98b20a8afcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d57119b8d5f9be848259d894d2d3fa00d36611763ba18770cc14b98b20a8afcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a7f1bb74c8de88b940841dc02cfbe7e2b64609b86345d51676ab60ef87c6fda"
    sha256 cellar: :any,                 x86_64_linux:  "0f51936e161309460a4e39218f38a06da22a76974b739a1e01f3b6d7bc491628"
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
