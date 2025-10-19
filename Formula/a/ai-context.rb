# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.14.tar.gz"
  sha256 "09ddbb4bc8eaf9c20ffed53dc9886057bdd5207b62e6ed9485b90369dda57ac6"
  license "MIT"
  revision 1
  head "https://github.com/Tanq16/ai-context.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a03b5c4f11d93e455756c54c267f6c10ec0098c1a246475cbbff56e46c45c37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a03b5c4f11d93e455756c54c267f6c10ec0098c1a246475cbbff56e46c45c37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a03b5c4f11d93e455756c54c267f6c10ec0098c1a246475cbbff56e46c45c37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de36e1597ec3903703a96ad3583323749aa4e6e6fa7f9356c3909074d812da24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fd78e6feafee01925adbe94cd027dcf275c228df231c920bfebcac35d517997"
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
