class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://mozilla-ai.github.io/mcpd/"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "38fb10516e386011379ddc6078c9b0c8f1961a8ddde76c78b7bc2c8048db3184"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f68ae739d5ab42190f4e4642c88bb22dcbc3d90201c8f0d10337d0da34bc41f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "257eb747e3fd3eb107e3631b7db39473b5d8af39d09effad2cebb7cd73a4b2d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df8ae3a720caad93f01e9750ec2b1d1065857566f22555bff18d33422047c1b7"
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
