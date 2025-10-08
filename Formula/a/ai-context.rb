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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95822cdcc4a9bf62e2bac6e428b6afacd52055d17b167e968772601860ebe35a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95822cdcc4a9bf62e2bac6e428b6afacd52055d17b167e968772601860ebe35a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95822cdcc4a9bf62e2bac6e428b6afacd52055d17b167e968772601860ebe35a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3083a83a9cd69220ad58652bb2d94552c150ce233bbf1bb06ec533075cad1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9267dacd969f92a7f7fe17acd07f3e96ed7007ee722243c73d4f8cdd6347ed49"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
