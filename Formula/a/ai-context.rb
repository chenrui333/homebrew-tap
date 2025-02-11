# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.2.tar.gz"
  sha256 "1496aaa70072b8b2871c2414869b1f8ce89a5d6d1ce9992c6859701bee07ca72"
  license "MIT"
  head "https://github.com/Tanq16/ai-context.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"ai-context", "--url", "https://example.com"
    assert_path_exists "context/web-example_com.md"
  end
end
