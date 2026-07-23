class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.16.tar.gz"
  sha256 "21c1874ac9b0d1ad9e3020211e1845dbe2ea5494bd977c0034775dee3a33bed7"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d9aeda15f7ad7907198bbabfd8c9dc95e9954be9af34a1c5ca0d5dfd766a84d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d9aeda15f7ad7907198bbabfd8c9dc95e9954be9af34a1c5ca0d5dfd766a84d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d9aeda15f7ad7907198bbabfd8c9dc95e9954be9af34a1c5ca0d5dfd766a84d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a0e555feef8bf4e10355e90ef7b52c3f5d0397ef9bcac5368c1428560405a34"
    sha256 cellar: :any,                 x86_64_linux:  "7e34be0c9916dd2285af820e4f3145eed7b554e839cd85002d0ed0b8bf9965d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/baalimago/clai/internal.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/clai version")

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
