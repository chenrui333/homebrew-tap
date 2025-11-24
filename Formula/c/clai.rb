class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "aecf548384f1313f1edaf26055072163fd48794fcee9b4dd2ee6e4206c1fd713"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83da1cde4eed5b6f4fdd39bdd87d38d004866ecdc1b21f309804cb7ce3882258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83da1cde4eed5b6f4fdd39bdd87d38d004866ecdc1b21f309804cb7ce3882258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83da1cde4eed5b6f4fdd39bdd87d38d004866ecdc1b21f309804cb7ce3882258"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad05eac595fbaa02b1403d69c10162aaf9d12f296be4cb0c7662ceb11542f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a841c04766ed8d84760cd45a7b9aad6685a469915e97d39f03b0b8b79484107e"
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
