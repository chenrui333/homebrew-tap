class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.21.tar.gz"
  sha256 "7e7c1742c83a5a5e1c4b646dd8cf764aa54afe816f7578326a237eab59bfcd32"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d282248e8dd106336bf6baa437c1e2f09928a97df91124bb5dd2f8ff7b125795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d282248e8dd106336bf6baa437c1e2f09928a97df91124bb5dd2f8ff7b125795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d282248e8dd106336bf6baa437c1e2f09928a97df91124bb5dd2f8ff7b125795"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a24950b246764a506641ad57387380082ee3fb5f198eb18639b48ddcba4abb42"
    sha256 cellar: :any,                 x86_64_linux:  "371d646e7f9604d038c1e1534efcb418ee37a996a0e670d777be826eb8299330"
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
