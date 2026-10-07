class Mcpsnoop < Formula
  desc "Transparent proxy debugger for MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "d23623dc356fde86a82eb1a8b82ca0f089d2e49f25a6576d55a22bdc238c221e"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f9808930780d844e3706f0eeaa10499ffaa2abe83f2b4925316e7b4170a66f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f9808930780d844e3706f0eeaa10499ffaa2abe83f2b4925316e7b4170a66f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3b46655f2042055f17c2c020167a04f3c9eef79f35d24e57805e40cb96e2976"
    sha256 cellar: :any,                 x86_64_linux:  "dcf903381c9745c2f4b6e7e5e609c8d6f717f8fc44388396fd721f489e80a451"
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
