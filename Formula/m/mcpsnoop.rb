class Mcpsnoop < Formula
  desc "Transparent proxy debugger for MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "d23623dc356fde86a82eb1a8b82ca0f089d2e49f25a6576d55a22bdc238c221e"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10631af26d2487e1eed9123e5c75d3e5091b06fbb9334b04d3444b6e90ceb983"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10631af26d2487e1eed9123e5c75d3e5091b06fbb9334b04d3444b6e90ceb983"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da733c63a041de2d77ae95b09b3cac0748adaf762b72ed87df2f9da6327e36f7"
    sha256 cellar: :any,                 x86_64_linux:  "27f2167806325281ebbf99c74bd3b25fcf141d7ccccb47d3eb97b323337f2e6d"
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
