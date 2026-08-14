class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://mozilla-ai.github.io/mcpd/"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "163d57393572e0ae73cded912ebdd1ec02051e9aa7ea0ced571bf78d6a14fd78"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f080632ee44c3e9b5f2b82ee3ecd9ee8ad515fd83dc66735f49fdb98725dce41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f080632ee44c3e9b5f2b82ee3ecd9ee8ad515fd83dc66735f49fdb98725dce41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f080632ee44c3e9b5f2b82ee3ecd9ee8ad515fd83dc66735f49fdb98725dce41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9abb818d59558ee24f90f37b70a3fdb5d336c9b2945c162105aadc0344d182a6"
    sha256 cellar: :any,                 x86_64_linux:  "e5cde2d82a022f1079bf132f0cd2903bbb9bcdc8a3d15b812eab0b92316ade6f"
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
