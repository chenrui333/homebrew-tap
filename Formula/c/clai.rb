class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "23702832ed0e91634187acc5cc1e8ccd87d17fc3d8e432983b6bf47c8a93066c"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea0d9c4bd1737620675a4ed12a4c5415e7daa05aad5bd03af600ccf23c3af921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea0d9c4bd1737620675a4ed12a4c5415e7daa05aad5bd03af600ccf23c3af921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea0d9c4bd1737620675a4ed12a4c5415e7daa05aad5bd03af600ccf23c3af921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4479da22032cbe07ac7f681f0b8b815a0d8616b43eb8811ac6466ec3838d9d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deb7702c2950192d9ad82da43162e436634bc9fb8c01f28b1d86f2bfb652de01"
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
