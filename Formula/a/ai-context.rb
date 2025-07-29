# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.10.tar.gz"
  sha256 "d776109efd9c4fb942252ec30fcc93a38045046cafc4c1208d398a5f14374881"
  license "MIT"
  head "https://github.com/Tanq16/ai-context.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74801a9ca8b827637948d6aeb184912527b94604b6b3c50a80247065c117bffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdc219523ff3a17bbf615b7169429f4f2b4dfad8db576eb9656bddbdfb0656e9"
    sha256 cellar: :any_skip_relocation, ventura:       "35d1c35c42a56d2215466f575aaf923854341394ff35b4ed2759bed5ee9120bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669ea9f1ecaeb94ddae2c2c7a3a9dd0b23a14e4072183b8ec460b3c51652b4b6"
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
