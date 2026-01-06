class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://mozilla-ai.github.io/mcpd/"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c06b129de66dabe715d3ac5fdf77a9cf4f06c53e54670b019b72f9f3589304b9"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed5aceb6c06f5da35faf3d0dbd87a6832b31d488eb6d2e328def95fdd0ec8071"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5aceb6c06f5da35faf3d0dbd87a6832b31d488eb6d2e328def95fdd0ec8071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5aceb6c06f5da35faf3d0dbd87a6832b31d488eb6d2e328def95fdd0ec8071"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5756cc153c415b08bf1879c03e6ef8e874d15d44f048f89494f82b4619bc0204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90efb62a32f8b13dac56ce2069febc778a604f29e87c2b4b2ded09b34f548724"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mozilla-ai/mcpd/v2/internal/cmd.version=#{version}
      -X github.com/mozilla-ai/mcpd/v2/internal/cmd.commit=#{tap.user}
      -X github.com/mozilla-ai/mcpd/v2/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpd --version")

    system bin/"mcpd", "init"
    assert_match "servers = []", (testpath/".mcpd.toml").read
  end
end
