class SourcererMcp < Formula
  desc "MCP for semantic code search & navigation that reduces token waste"
  homepage "https://github.com/st3v3nmw/sourcerer-mcp"
  url "https://github.com/st3v3nmw/sourcerer-mcp/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "91d4d05112dba2c51f0575a70fa2e02d41c0c946f23182b48ff6e6971cb5815b"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87595c6fce4bf3afe5127debd722ddc24fc0c37e457cc3b0be9c61a55528e9d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcc2160ae32938e06aa094b1cee45783f0a340345ee584dded892a2ca83acfd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "328d1a3c020998c8124db070d91ff38163541363b023a8167e2abe0bbb3e393f"
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
