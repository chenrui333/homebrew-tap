class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://github.com/mozilla-ai/mcpd"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "06b8d2df2c06f5abaac4b31c4388e07cd42f53059bd99afc6274cfbb391982ab"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b4ee68c1a03fe19d66c4205e7b9ca20652c33da2c23116a336d926cb9335869"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b4ee68c1a03fe19d66c4205e7b9ca20652c33da2c23116a336d926cb9335869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970384833389b37b65f18370e909e7324343e7c9c84b47b1832d376ba81f6c89"
    sha256 cellar: :any,                 x86_64_linux:  "2a3018e8038ebe6d2eb76d9573271806d60d1dd7a7eb4a614c28adc007440d0e"
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
