class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "d522b11ee2be6ba8eea2048889e8f9e70eaf9224e64f629bda937586dea968c0"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad5c20b8a0a729662fe4bbdf9a2e899414c3621788bfbef77f5d0acbb8670d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad5c20b8a0a729662fe4bbdf9a2e899414c3621788bfbef77f5d0acbb8670d6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5c20b8a0a729662fe4bbdf9a2e899414c3621788bfbef77f5d0acbb8670d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1696c4a208f50678668adda7a8a58be50bd79b6d2bffacc2027f0b7ea2cd152a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e25e077d58d63f16fd7973665df78aa757bd931c958aa6f60fcd11769739178"
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
