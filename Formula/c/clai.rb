class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "8dce081fa2fd99d4c996648e3dde9724c437ec145ecfb197093321f301e9114f"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "181c1f6975bb59a5642b0d72cbcf111c6e18ef53dd88ce8c68d3aad429df4586"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "181c1f6975bb59a5642b0d72cbcf111c6e18ef53dd88ce8c68d3aad429df4586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "181c1f6975bb59a5642b0d72cbcf111c6e18ef53dd88ce8c68d3aad429df4586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b10374994475d813c33f9beb1547c7feb505b6f78005a93bcacad94c2a37aabe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bae070ea1ebffafa54deb44e983831f2e2f879308b86ee0eb6b36b235e939fa"
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
