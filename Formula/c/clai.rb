class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "e646a49b22522420d39f73d5f1131ae26b6637507faa226e81948ce26ea32918"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af4289fbf60fc67803ae2b290021976e34ce126dfa9bd575c70ca920d7f4ad6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4289fbf60fc67803ae2b290021976e34ce126dfa9bd575c70ca920d7f4ad6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af4289fbf60fc67803ae2b290021976e34ce126dfa9bd575c70ca920d7f4ad6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c08b2088387ee9749f196caaa3b2a1fe8a447196e70e460a446deb73df33fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85378bbec2b71f79f340cbf47bbe77323c9f7eafdfb944f9c4e578daddf5d389"
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
