class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "e646a49b22522420d39f73d5f1131ae26b6637507faa226e81948ce26ea32918"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e827beae154419b9cff07d1335d5395b64d4c2ce192deb29f2abfeb8d7682ea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e827beae154419b9cff07d1335d5395b64d4c2ce192deb29f2abfeb8d7682ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e827beae154419b9cff07d1335d5395b64d4c2ce192deb29f2abfeb8d7682ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4768562bad4a16f1ced4a9448036d695dffe7097dc4f60d9d85b7914410b285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3d5c34b52d2b17a0f0037bda35008339868e26d54b61f7b128336a6708f7467"
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
