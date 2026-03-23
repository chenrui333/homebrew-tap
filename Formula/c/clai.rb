class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "0d5bb1861aceab89c18fe26147f12628cd63e924b854755f5ae9b778a1223803"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd52b1d73f624e74474238a32b5025403439c23c1e2fbb92469c41402595b4fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd52b1d73f624e74474238a32b5025403439c23c1e2fbb92469c41402595b4fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd52b1d73f624e74474238a32b5025403439c23c1e2fbb92469c41402595b4fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f5b0d9648b3d704942592906cacd9226eb9c35b37e42920a0dd52d229814c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d7a6cc4fd2f92068b1071eedda435c0f4ea46d4cdce88419d4286d994670337"
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
