class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://mozilla-ai.github.io/mcpd/"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "26682845c7a613f2809cfe95232e1601b753188f45e005323b8bee148a6f20d6"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49c784e2d2efbfacc83fa67fb3d5d93b88721898f391a8a8bd75dacd64c50635"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49c784e2d2efbfacc83fa67fb3d5d93b88721898f391a8a8bd75dacd64c50635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c784e2d2efbfacc83fa67fb3d5d93b88721898f391a8a8bd75dacd64c50635"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5b2c3ded9838b7d06cf7487a537d59acf0985b6af3b8b885452d1cecc1c207d"
    sha256 cellar: :any,                 x86_64_linux:  "6c5cc855a3e9ace5b882281ad0cb848c9b1a1df66998b7be1134b4817580378c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mozilla-ai/mcpd/internal/cmd.version=#{version}
      -X github.com/mozilla-ai/mcpd/internal/cmd.commit=#{tap.user}
      -X github.com/mozilla-ai/mcpd/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpd --version")

    system bin/"mcpd", "init"
    assert_match "servers = []", (testpath/".mcpd.toml").read
  end
end
