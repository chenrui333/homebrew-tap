class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.9.tar.gz"
  sha256 "cfae8e5a263cf8ca3fed5caee1cc267ebf443f3908eb1b32599a4a44d2807b75"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c71a9b9ce1850d41d67a9984a3694915402f8c57118cb5ab571379b4707fb47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c71a9b9ce1850d41d67a9984a3694915402f8c57118cb5ab571379b4707fb47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c71a9b9ce1850d41d67a9984a3694915402f8c57118cb5ab571379b4707fb47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e66c90635aa11791179330cc63c0e79f9bfac1a6c43f450a3b0cc2a1ea3e964f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3351b02989ac3b7f4b85c22f6ee39d7ae879e0579f40ee6cfcbfc0d7d971b234"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
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
