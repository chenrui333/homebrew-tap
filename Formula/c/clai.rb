class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "3523d96d799d6619a39e7bd32bba8818140931ec8657693acc09ac6a5c1b0e84"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f42397f60853de6e81f1bfaa165886f755e7273b5a15a3930dd8f8b9e582cc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f42397f60853de6e81f1bfaa165886f755e7273b5a15a3930dd8f8b9e582cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f42397f60853de6e81f1bfaa165886f755e7273b5a15a3930dd8f8b9e582cc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbb0662397c1d6cab5cfd777b3bd5cd475c91913f62938f5ffb41516ddabc8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c62ea3af418fa41418265920ba77fc836bc37870d898a12b19f706fce9af8c87"
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
