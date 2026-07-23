class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "0beca68edab6567792f5e64ad7685fa2f0557464a46b1d4a1fbf6b00de2b04be"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61b8315e366c7926266c5bae3c0915520107a7d47077f34bf930d2c7fa696aaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61b8315e366c7926266c5bae3c0915520107a7d47077f34bf930d2c7fa696aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b8315e366c7926266c5bae3c0915520107a7d47077f34bf930d2c7fa696aaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f91e02f79772a3700711bbd706ab934bc44bd8ddf6957bae58efb1e587af0ae8"
    sha256 cellar: :any,                 x86_64_linux:  "2b15c7b84d948b9efa1821183e55c80edca769393328740d38a12448b20d1554"
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
