class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://mozilla-ai.github.io/mcpd/"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "2b84d8f68983764593b0b7cd305b0b118c79e401d47ecc165848e746390dcd5f"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "029b4b7383d007609d829bacd0938474bdbd1155d7e609abcb615f44e21eb1eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b614bc267d070f94c4583eba9989d9e4183543c3555015912026951b81e65b72"
    sha256 cellar: :any_skip_relocation, ventura:       "df70511c3c673c56622f52c88a5b3b68ed6311883ef98ddb8a1aa93b2e1bb57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cb3e19201fc0eeb8afd3d9723599a3706bf3c0fdd5535554a4fb2299870bb74"
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
