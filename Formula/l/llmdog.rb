# framework: bubbletea
class Llmdog < Formula
  desc "Prepare files and directories for LLM consumption"
  homepage "https://github.com/doganarif/llmdog"
  url "https://github.com/doganarif/LLMDog/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "aa1b6770ca0e853cd426a23c2f1381e328796debab37d00f64a9a96b055cc589"
  license "MIT"
  head "https://github.com/doganarif/llmdog.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/llmdog"
  end

  test do
    # llmdog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/llmdog --version")
  end
end
