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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48fd0379680cadd503e75f45afb9677623d9975ca440f5bf8a94d127e094d862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "891162255410edb754a341a22c3df1e2513448a894934bb66ad33e822f059011"
    sha256 cellar: :any_skip_relocation, ventura:       "b19488a5919593b478dc51dcae1eab548e0a0fd85cc719f87aef1d609e6e652c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85296034960af830c9e808965b06ef698296ad6eca6a2bb0ed4c0549a5dbdc5"
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
