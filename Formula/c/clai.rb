class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "2df65c20d89b176d2a3d8f321609b863f72c29112103163c5f1e6de072d31561"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7187ecfb565e1d0f92ac075d443ed61c7d0de3104cdef5ff270d556f39679cae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7187ecfb565e1d0f92ac075d443ed61c7d0de3104cdef5ff270d556f39679cae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7187ecfb565e1d0f92ac075d443ed61c7d0de3104cdef5ff270d556f39679cae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e21ea05a3f5cb5a3aa66051358f7be0eefa8835797413e5081df019e0e1719de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3b48b62ee7adfa83986e119c41aa99ae4116ed0d3b20d893fbae305c6a7f33"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/clai -h 2>&1", 1)
    assert_match "Usage of clai:", output

    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/.clai/conversations"
      assert_path_exists testpath/"Library/Application Support/.clai/profiles"
      assert_path_exists testpath/"Library/Application Support/.clai/mcpServers"
    else
      assert_path_exists testpath/".config/.clai/conversations"
      assert_path_exists testpath/".config/.clai/profiles"
      assert_path_exists testpath/".config/.clai/mcpServers"
    end
  end
end
