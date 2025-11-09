class SourcererMcp < Formula
  desc "MCP for semantic code search & navigation that reduces token waste"
  homepage "https://github.com/st3v3nmw/sourcerer-mcp"
  url "https://github.com/st3v3nmw/sourcerer-mcp/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "4b838a32c6f9e249630d3175bc4f752b9404508f015a1c5b2fb63231eaa47a4b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "266b8056d242264de392125ee3fafda78c25d33f327b27bf7c76e353d88a9a9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26aeec947b36389f2c56657900d935975d8d5e3fe7dac205f98d827ba3055d6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48aff0d5e43630f461df0a76a95e6da975bf13e1ce2c47c0aacdb4acef856de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f8f0250283a7ae2642a1c3b559cbf849c4fc2c1456f9c4e6980464bb4d5910b"
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
