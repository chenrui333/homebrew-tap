class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "8dce081fa2fd99d4c996648e3dde9724c437ec145ecfb197093321f301e9114f"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4643bd72ada0d724082d1ac219884c3333b0a44aa3bc06f12b1c14a7d8d1e3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4643bd72ada0d724082d1ac219884c3333b0a44aa3bc06f12b1c14a7d8d1e3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4643bd72ada0d724082d1ac219884c3333b0a44aa3bc06f12b1c14a7d8d1e3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2020220633f0de8c977a5d1a1bf111c6e4e344938bcbef4cc89c608f54204f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1439a6f1c2187e08a00794e62440ec4c4e13dedb099b966abb2dbb86f851be"
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
