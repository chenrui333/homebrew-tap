# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.14.tar.gz"
  sha256 "09ddbb4bc8eaf9c20ffed53dc9886057bdd5207b62e6ed9485b90369dda57ac6"
  license "MIT"
  head "https://github.com/Tanq16/ai-context.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db24ceb6f3991159e84a54b67a2948814206008144239c44a41969d2b74e8a7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da5325ae78c61e97ac40b6bf9f21be085d5b2e92ffde9b32ff279a5177b95b03"
    sha256 cellar: :any_skip_relocation, ventura:       "bd94d479c29608e1431e6a6b7e88d9d5e6a2f6a4b062fa3d9085b78fdbac81fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85730700e6ec1c9c41a7a954362acd41e0adff7cf2b84c3f130ddc15f6e0b85"
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
