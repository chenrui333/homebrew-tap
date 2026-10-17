class Mcpsnoop < Formula
  desc "Transparent proxy debugger for MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "192e643eb897aef5f3025f00b0ba5b09d2eee2fb2a79b4c00de1e4e602573a88"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0091e7d28bc6c6785cf903a2f8133b6960ccee3847f0c514144ec087b09c7b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0091e7d28bc6c6785cf903a2f8133b6960ccee3847f0c514144ec087b09c7b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8d4f33c4ce03946517ea6dbac0b4f8031d4eda57cb92a0cf71b3c890510f5fc"
    sha256 cellar: :any,                 x86_64_linux:  "4c73ce61e0fa1616403b72092b62dcbe954e9ef86d9eecd1485c631690c14388"
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
