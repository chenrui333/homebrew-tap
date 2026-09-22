class Mcpsnoop < Formula
  desc "Transparent proxy debugger for MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "8f30e4bee02d7656d423d86da272af7907185729ce070de3ad40bcbd006229d7"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fb2e80d3c450abac8f1c0304338c1952e3d57f62cef0e7cf6c2ad5c2f8907f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fb2e80d3c450abac8f1c0304338c1952e3d57f62cef0e7cf6c2ad5c2f8907f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e515bdfbd18bd1d8801f720eb168a0f87749afd89a511e7d07d16a595615efbf"
    sha256 cellar: :any,                 x86_64_linux:  "16ac63af413c5d17e99d6abbedfd038e082ebe1cc259af2eacc8769b3ff2d624"
  end

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
