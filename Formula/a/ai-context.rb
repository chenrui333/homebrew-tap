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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fd73998b739dde886a155f89d5055118c51f4aa082264b3652933b80227ef74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b92058000f6cdf7d8acf16920a0f694898d0c0b0294b8a15564630c98b9d62e"
    sha256 cellar: :any_skip_relocation, ventura:       "4df64883c099a9a173f2d3d2139c5bf3a7f81fb12212d67a967ec3b1e39fad2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7add016ced38ea1621c1a650a12895d206a46dbc1efb55061ca0310a449cfe"
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
