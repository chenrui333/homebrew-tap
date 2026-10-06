class SourcererMcp < Formula
  desc "MCP for semantic code search & navigation that reduces token waste"
  homepage "https://github.com/st3v3nmw/sourcerer-mcp"
  url "https://github.com/st3v3nmw/sourcerer-mcp/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "f63dbacaa0ad4a6b2e42f9df2454830234d86deac689d2f5784945120cb7740c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d08d0742ae243ed89817fe8dbd453517bca525b4e9d60f5a6081ac3500e8aa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b4f8cacf9de65b5ea6149c3bffeea1217c9a305549d4f6ea786a203adb298fc"
    sha256 cellar: :any,                 x86_64_linux:  "91a04ec65e331a3a79e3398eb2cfcd27a17ba0bc8e2dde421fb96deb49c71f63"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
