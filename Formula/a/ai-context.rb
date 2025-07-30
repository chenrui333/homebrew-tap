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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e6ca78be432bec832613767cc93497312206f8c9aff25d179a7b64bd11e391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "520c2f4944a49ae21f6ab2e35b3dd10c12fcac7dfc5d9da5b103dbdd3ef63ab9"
    sha256 cellar: :any_skip_relocation, ventura:       "b9e9b480ec5854ebc84652a62149c01a0aa47ad856b6d938573b03badbb1caa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a064c654e00d1573faa9fded90ddc8064621e38f1387b623c9743a8f0d29b2f8"
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
