class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "e071219b5afcd624827cf4401448052b05067ef7c8d5f7793761f5383bb5ee49"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63f7c8db991ae18717381375cdfddb182edda4bc834c17164eeb511d211ef5a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63f7c8db991ae18717381375cdfddb182edda4bc834c17164eeb511d211ef5a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f7c8db991ae18717381375cdfddb182edda4bc834c17164eeb511d211ef5a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a5c1d1268f6b1af1ae1a70e9e4ef9179d7656fd73a4b43a7473004c26f7955f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea0899011934eeaba80bcf4fb70808484f45621acfadd21b119a746ab72dc8e"
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
