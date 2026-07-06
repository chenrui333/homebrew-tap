class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.11.tar.gz"
  sha256 "6410fa39465719355b740962d733aaab5d57da3e6a97cd24940c5ac93b8ba9ae"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a6b92df11d44236be8bc11886202017de1f0636ed8d4e19246109362628a0a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a6b92df11d44236be8bc11886202017de1f0636ed8d4e19246109362628a0a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a6b92df11d44236be8bc11886202017de1f0636ed8d4e19246109362628a0a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9ddd952c8abd82ca0f042204054cb135c86b1d33c96a2a4121d7781f3df4c55"
    sha256 cellar: :any,                 x86_64_linux:  "da8ed1b7c83e57575a5088cdd75e781ea7a0b74a5b6b3453366b51bf75eae9dc"
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
