class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "af379f8ca953bbc0fbbf3119f2961a52b1c55d28ff900b48d242ab15a3b31a54"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55817db7f440d7ce0f983f0eed2c089e2f3fef162da1769b0d4786f2e163efc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55817db7f440d7ce0f983f0eed2c089e2f3fef162da1769b0d4786f2e163efc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55817db7f440d7ce0f983f0eed2c089e2f3fef162da1769b0d4786f2e163efc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7766e865b75aac4d23b8b27ed44f976b8620190960e1af5ed22f12623d4b5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bcc07c1d45c2795d01017334f0ed9e587d81a055526565c58d22068440615a4"
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
