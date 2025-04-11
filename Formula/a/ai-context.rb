# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.5.tar.gz"
  sha256 "003c2071fe24df9879da592202b16e05006115b26ffeff52854a25ee9138c544"
  license "MIT"
  head "https://github.com/Tanq16/ai-context.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f751a6e3c14a260d6ce3f35cd7ef9af4f48ce86f09292053077260b04112f52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "269b47805102f76707fc5fb69adacb4993d93519f996609b771eea65b4b4ee5f"
    sha256 cellar: :any_skip_relocation, ventura:       "65e732d294264771f567ff4fb52215faf86d790791dc8666a0764390ab689389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8757528f85594c4e3d907f2725ef578fcd24c24309582aa2f74d6451c48b759"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tanq16/ai-context/cmd.AIContextVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["NO_COLOR"] = "1"

    output = shell_output("#{bin}/ai-context https://example.com")
    assert_match "INF All Operations Completed!", output
    assert_path_exists "context/web-example_com.md"

    assert_match version.to_s, shell_output("#{bin}/ai-context --version")
  end
end
