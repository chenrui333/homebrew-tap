class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.20.tar.gz"
  sha256 "498e0cbf7337dc1bf3d65b8a3937607c8da887673c2792bb15b49e05fbaac2ea"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fc848debca985a52ff0729d13d73e6de1f6f60650e8678d530f722f09b6c57c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fc848debca985a52ff0729d13d73e6de1f6f60650e8678d530f722f09b6c57c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fc848debca985a52ff0729d13d73e6de1f6f60650e8678d530f722f09b6c57c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "230653e81afe75815c8a14da8b4596de6d53a674b88bf375d38b6d57b38cccc8"
    sha256 cellar: :any,                 x86_64_linux:  "e1c59020818fdb52a41069ea522f537c6070aa2cc0eae85cc39eba14c97df51b"
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
