class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "2c1598e8e37ae904afcb2911fe8e295ed7913f394895833c0f87e352973a6d79"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7487b980c80aaff67ec45e2479dbff4d6c604e0783c42b6cc6858eb7098ed6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7487b980c80aaff67ec45e2479dbff4d6c604e0783c42b6cc6858eb7098ed6bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7487b980c80aaff67ec45e2479dbff4d6c604e0783c42b6cc6858eb7098ed6bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96115866b5fe7b22d117958e920422962a88058d2d520343c4548fce14b8251b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "602aec264a186bf77ddfd6f4dc6c4e1b0a5be411ac3abcc5c88c6646d3fc8d51"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"clai", "-h"

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
