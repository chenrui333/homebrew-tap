class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "4b018579b4fa53af31f52421f0fbdd67a921e5d9f67a77c06c9880d41b23235b"
  license "MIT"
  revision 1
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "412735d2b73baeb9ea61e8de1acc26a122a9a539690716dd47145182071eb192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "412735d2b73baeb9ea61e8de1acc26a122a9a539690716dd47145182071eb192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "412735d2b73baeb9ea61e8de1acc26a122a9a539690716dd47145182071eb192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acaa9dd9c15c7dd77155429ea605e86e54fe96351263b0b546403db98728c6fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85361325d3fd447384c8992d2528bf8e269df16f9f64182679f9c970b0bce21"
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
