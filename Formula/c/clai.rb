class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "faff64d721afd988a585b729ba848a1382982c9394f65a7b5a12b906534872ce"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72a58f19190b0d81b3741ffbdf69d97cdcfcca303ad6303fff07d7cff6d3e802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72a58f19190b0d81b3741ffbdf69d97cdcfcca303ad6303fff07d7cff6d3e802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72a58f19190b0d81b3741ffbdf69d97cdcfcca303ad6303fff07d7cff6d3e802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9cbd2a9e5f86405abd0493e26cdd32ae5d819fce04eda5095a49e8a2ff974a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7b930c6588bf132904c8277cb4ef501222dff40b39b6bc50d30f231d5469620"
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
