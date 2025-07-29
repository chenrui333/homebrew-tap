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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9548e5898c5baa92aa37b1bfa8090ca77e1a5e371d289edbaa145c2d78372dcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c421c67b987b3a45cb34f78cae6abb41c1c6f78d07ead42c9562bd1b1c6b51a6"
    sha256 cellar: :any_skip_relocation, ventura:       "517162f9f58831ecb53f69cdfbf95a6f09e2179329636b35ec741b41b17dc405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2633b8a47c90600365fbcbebf014c8c468ece7a39a975353f58abe8e7d358a4"
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
