class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.16.tar.gz"
  sha256 "21c1874ac9b0d1ad9e3020211e1845dbe2ea5494bd977c0034775dee3a33bed7"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e4b02b104a42b40fe168ba97648161ef7cda244bf6800609a717c00dd33e785"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e4b02b104a42b40fe168ba97648161ef7cda244bf6800609a717c00dd33e785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e4b02b104a42b40fe168ba97648161ef7cda244bf6800609a717c00dd33e785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e07eb3701acb8829168a9bf7d8328bac8653574d7bc81d47bedc51af49508a23"
    sha256 cellar: :any,                 x86_64_linux:  "28023360c187e4dc13e0157dfa41f205c2511b09544e13caab608b05b1ca5432"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/baalimago/clai/internal.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/clai version")

    output = shell_output("#{bin}/clai -h 2>&1", 1)
    assert_match "Usage of clai:", output

    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/.clai/conversations"
      assert_path_exists testpath/"Library/Application Support/.clai/profiles"
      assert_path_exists testpath/"Library/Application Support/.clai/mcpServers"
    else
      assert_path_exists testpath/".config/.clai/conversations"
      assert_path_exists testpath/".config/.clai/profiles"
      assert_path_exists testpath/".config/.clai/mcpServers"
    end
  end
end
