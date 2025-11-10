class SourcererMcp < Formula
  desc "MCP for semantic code search & navigation that reduces token waste"
  homepage "https://github.com/st3v3nmw/sourcerer-mcp"
  url "https://github.com/st3v3nmw/sourcerer-mcp/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "f63dbacaa0ad4a6b2e42f9df2454830234d86deac689d2f5784945120cb7740c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd2893223213a3e90c7b12863c13602b54ef953fb32444e1795b7965f8a87ab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75ad1ae8195a88ec24c3bedaed05288dafa648e77b4234e6c1b102c84baab3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac11afb05940d0bb2fccfa838dffaf25483b6c0f08d4c8b044d7e3301ee9846f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e081ed82ae1db7bbc149b560db286aab016278077b9bdbf97db9df852fdc810b"
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
