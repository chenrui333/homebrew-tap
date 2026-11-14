class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://github.com/mozilla-ai/mcpd"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "06b8d2df2c06f5abaac4b31c4388e07cd42f53059bd99afc6274cfbb391982ab"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "289e5b4522dd937c2aca45a07e2e597b8c68850c73c20c49ccc33223b788894a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "289e5b4522dd937c2aca45a07e2e597b8c68850c73c20c49ccc33223b788894a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "001c8cafa8a117ddccdf4c8c1a787bde8d0d14c758d8ae26b9b9e2963bc159ac"
    sha256 cellar: :any,                 x86_64_linux:  "4828b41fda15ebff2e49442542ee5552a78f14098faa979c30d34489804d4d9e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
