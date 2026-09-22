class Mcpsnoop < Formula
  desc "Transparent proxy debugger for MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "8f30e4bee02d7656d423d86da272af7907185729ce070de3ad40bcbd006229d7"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/mcpsnoop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpsnoop version")
    assert_equal "", shell_output("#{bin}/mcpsnoop --no-trace -- /usr/bin/true")
  end
end
