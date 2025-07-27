# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.8.tar.gz"
  sha256 "4e2f19acee537805cebfc9d523c0c1224a43ee64b4653596ee2ae810d4fadd16"
  license "MIT"
  head "https://github.com/Tanq16/ai-context.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e5e4ed7ae0d205040ce20f7623c4530e645fff152f4bf5f9bd2536a36a8369e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "973a9fb41d8f3efed945ec05cfafda3cd4def200ca87c5ae2e01e82857518279"
    sha256 cellar: :any_skip_relocation, ventura:       "b845f98232258c4c1f729251b829ee0c81eb5beb599f530e313c5df522524b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c148be6f7b2244a63499be713010f5a9f58b3865bcb6cacc7dd8f9817c6ffb2f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tanq16/ai-context/cmd.AIContextVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["NO_COLOR"] = "1"

    output = shell_output("#{bin}/ai-context https://example.com")
    assert_match "All operations completed", output
    assert_path_exists "context/web-example_com.md"

    assert_match version.to_s, shell_output("#{bin}/ai-context --version")
  end
end
