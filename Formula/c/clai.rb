class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "d0838ef457ad12c976ec1dcf7d7b285a273750d10e8d68afa8f85dc0e7d93598"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7883edb3cb36b51c0aec180e7734fd55439eb19addf851caa80e9552f56f01b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7883edb3cb36b51c0aec180e7734fd55439eb19addf851caa80e9552f56f01b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7883edb3cb36b51c0aec180e7734fd55439eb19addf851caa80e9552f56f01b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8bcce15a5c3797eff80dc3948ff1fe036b673f1e70d760ffe15630dbe6ca1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0506341a0b3bb9f0a40c8326218b7ffadc86b80b0d0983210ecc26352f9cf6"
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
