class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "0f6264d9cfad8fc0ebd8fa744ef7fc7445ccd60a55593ff6d9629fade404e2fe"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03fbccc5d2672b4610f6f4062a6344625e70361a06802d0ba19b89621dcc2393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03fbccc5d2672b4610f6f4062a6344625e70361a06802d0ba19b89621dcc2393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03fbccc5d2672b4610f6f4062a6344625e70361a06802d0ba19b89621dcc2393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84119e662016e9b2ad7f8011f008a63e943feaca34889a7ec90b4e9fb46d4cbe"
    sha256 cellar: :any,                 x86_64_linux:  "de8924048b6c752cb554fa29b1fbd77d62c6da510797337742b6adc9c8f5759d"
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
  end
end
