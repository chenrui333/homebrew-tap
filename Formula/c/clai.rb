class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "17889e7bbc543ece175d38b7868519e4a1de9191e5d925ed562a2d816e8b44ff"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18456bd84360e5a3b69a7457323fe6662fe89e225b8ca2a17782b02fa80e1020"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18456bd84360e5a3b69a7457323fe6662fe89e225b8ca2a17782b02fa80e1020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18456bd84360e5a3b69a7457323fe6662fe89e225b8ca2a17782b02fa80e1020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb1755c52e97db31e6c75a7c002e9a7abf211e47300f821535f0acaaff465723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7688fd42a84ead275e9ff1b91571d816614c1c5694942f3102c737c721795379"
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
