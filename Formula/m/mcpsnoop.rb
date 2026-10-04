class Mcpsnoop < Formula
  desc "Transparent proxy debugger for MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "db65c3617838cd9ff1b3b99982a0dc7b10320a469c3f53467679aff9f2f0175d"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c37a461f1268f8b7d3c471cee15920bdfd652952ca8796a0a3b4de572c2623e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c37a461f1268f8b7d3c471cee15920bdfd652952ca8796a0a3b4de572c2623e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74c1d745e2f72ffcbcf09ebfd45bee15ac6706f2612f526fd6a21f60257134cc"
    sha256 cellar: :any,                 x86_64_linux:  "5847ad7c916002c1e74a6068e9392d09bf72cce3cc7aac7c4ec295ce9b903f03"
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
