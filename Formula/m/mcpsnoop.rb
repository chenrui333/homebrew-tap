class Mcpsnoop < Formula
  desc "Transparent proxy debugger for MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "c68b915bb0cfc248cd72d04f55898f34cd0904076338074389e6422d3142de95"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1192962462dcc8fb3065284f80621399895b20e7a3cc7d46211c2cfd1848704e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1192962462dcc8fb3065284f80621399895b20e7a3cc7d46211c2cfd1848704e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e65c0a2f4350db19bde37635544d5f57d7681c6a48a09d92f9d500cb2b128d70"
    sha256 cellar: :any,                 x86_64_linux:  "86168985fa1056be39201310278c8a1079b6441fdea7e8101e6f71f1c20392bb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/mcpsnoop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpsnoop version")
    assert_equal "", shell_output("#{bin}/mcpsnoop --no-trace -- /usr/bin/true")
  end
end
