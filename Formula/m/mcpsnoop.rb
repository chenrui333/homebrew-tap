class Mcpsnoop < Formula
  desc "Transparent proxy debugger for MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "c68b915bb0cfc248cd72d04f55898f34cd0904076338074389e6422d3142de95"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9703f69590788a9295053b685380cb4072cd9cb677a405eb3f82b2d4e0016819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9703f69590788a9295053b685380cb4072cd9cb677a405eb3f82b2d4e0016819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5adc241db617aa398c92054482b0e3499476a63166f6556c1d2821fee42f21b4"
    sha256 cellar: :any,                 x86_64_linux:  "7e894e923c3402e975b7ff7bebcbae48aebafd3a6ec39a83c0b30f056d993c36"
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
