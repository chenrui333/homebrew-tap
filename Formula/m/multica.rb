class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.22.tar.gz"
  sha256 "fe27bcbe2129e8d646195768fca5420c7a2e69f9013af7f80f66a90c0a4b4867"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a96e8709ec75dfa7710454718bcaeb589012e2c0963bf20356cd5aead32d37bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a96e8709ec75dfa7710454718bcaeb589012e2c0963bf20356cd5aead32d37bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96e8709ec75dfa7710454718bcaeb589012e2c0963bf20356cd5aead32d37bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61305a0b2adc95dc0027324cc1739de822b42d19e373226cccae5e093f70a2f7"
    sha256 cellar: :any,                 x86_64_linux:  "9d2d4c86ec07383cb7a1fa5b17f6b329effedbffe16bce1227bfc8cb19ba59f8"
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
