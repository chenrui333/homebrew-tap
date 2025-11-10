class SourcererMcp < Formula
  desc "MCP for semantic code search & navigation that reduces token waste"
  homepage "https://github.com/st3v3nmw/sourcerer-mcp"
  url "https://github.com/st3v3nmw/sourcerer-mcp/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "52180e163528578a9038916000fe640f523d24828faf6870a89d35259c60b363"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1b9644fc3c413986d01d3783f8bb9b86769ffb67e95d4e976d5f97b089d8195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5668a854753499f521fa80d696a601d32c1b87e750bf71dbb389c3d7dc674c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef5266a79b5f15d85ef24a7c9b2ea6712c7d0086eea15110a168f71e7e164e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7523c8d441f239b999220cd18da4f9d87459cf3a957265c786bbd396cf053f3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"sourcerer"), "./cmd/sourcerer"
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    ENV["SOURCERER_WORKSPACE_ROOT"] = testpath

    pid = spawn bin/"sourcerer"
    sleep 1
    assert_path_exists testpath/".sourcerer/db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
