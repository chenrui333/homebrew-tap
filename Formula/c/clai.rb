class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "e5f3c4c2e574694df8766ccfd61cb9ce0c0b229ecd637146e14ce09da2725339"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3083d09df2539b67e622722997078e7ef997b1adf363e2f1ac3b74c88b4b09d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3083d09df2539b67e622722997078e7ef997b1adf363e2f1ac3b74c88b4b09d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3083d09df2539b67e622722997078e7ef997b1adf363e2f1ac3b74c88b4b09d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ecf4b3db0ac930a8395322e7ab0c1b1bb11708040500039c9be2e219b348747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84bd4a82d04933648d9e7e3880bea23c866ab5f996143dae45e4d0f8b7fcc098"
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
