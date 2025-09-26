class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://mozilla-ai.github.io/mcpd/"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "d611fd8cee54f7e1f9f5849d59d825943def80abe8583b49f848a1bae5fd8ac6"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a99a5247dec3072e72ea6851216b7627646ef79c199415c9562470bb1cd24b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cd97f2230ff0fba49fff3880c34f6c212ff806dc8aaeba41872b29fb718d615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11cc0e49a294679b5727397de8f74534f00b47c1db7da5c1cb7212d9d8843fb2"
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
