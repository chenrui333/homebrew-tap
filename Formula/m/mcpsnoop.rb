class Mcpsnoop < Formula
  desc "Transparent proxy debugger for MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "3f82a4f73567093841a3453440d56e3473b113d3ce3ff3493fdc6522f235bc3d"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba4b0940b73ea67cf47f204f97988400b65b14ba7a6afd39aee86c7d4790521a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba4b0940b73ea67cf47f204f97988400b65b14ba7a6afd39aee86c7d4790521a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b716f626ef5dcfa6b94dc794b5bd4cc17bf40e598fb975404b46c738a70a22ed"
    sha256 cellar: :any,                 x86_64_linux:  "f16b3106e3c4bc774400dd4e6acda078f296a8c775d8d68723dcedb72f2e54a6"
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
