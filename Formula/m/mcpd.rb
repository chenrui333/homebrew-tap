class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://github.com/mozilla-ai/mcpd"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "2d029fe67f9e3547719fb967b0a39b83502a557fd59f47e15b6e02694496749d"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30c160c18498a4b8a88ca68420357cfcfbafd4583787362a17d831cef2fbf197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30c160c18498a4b8a88ca68420357cfcfbafd4583787362a17d831cef2fbf197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85ce034e4d85aab55aa4cf78a90007065d20a0a0769008478525466edf05d4de"
    sha256 cellar: :any,                 x86_64_linux:  "71548ef106fc7186e74e704536e2c6e617fe2c2a6790b146187113e3917acde0"
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
