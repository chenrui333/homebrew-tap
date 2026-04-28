class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "fbefd120941e01320bfccbccada6614014c0626f969ca4ace9a6b489333fe165"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cfa127d072fa0c1ae861cc6c315e664d18b3d48ef8a0e78f98ce094e3c86a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41937e1a6fc679083c017a096a63aff7774aec9040a9d03accb0d82a58e074e1"
    sha256 cellar: :any_skip_relocation, ventura:       "5350ce95d545bfd960acdabc9f89ea48ecd16a9e63daff0e4a62dd2f3196a208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bac006757f0159c5db3695a20368648d4623fce4cf4b95d20c3ab251859a42c2"
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
