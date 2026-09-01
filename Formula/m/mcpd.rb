class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://github.com/mozilla-ai/mcpd"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "7191c171e423371fec0b8c2d6d638e1af1faed146d146fed4c06a1be07f2d952"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a311f18730a6148af3e34522b36cf4931d6eae716fe1fa12e97b53fccabfea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46a311f18730a6148af3e34522b36cf4931d6eae716fe1fa12e97b53fccabfea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a311f18730a6148af3e34522b36cf4931d6eae716fe1fa12e97b53fccabfea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "595b83db00e792e06c32cf7744ddc24739012daf3c99c47f8faa60f9861bb2d8"
    sha256 cellar: :any,                 x86_64_linux:  "12a08ea9086775db68643218f9efce2eb7880818dde11b9bcb74e709e9612945"
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
