class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "af379f8ca953bbc0fbbf3119f2961a52b1c55d28ff900b48d242ab15a3b31a54"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d205a6aaa4c37e4d400890a65ca3d8f7b96e0fe1e4e2ac0ed93c20948974b3f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d205a6aaa4c37e4d400890a65ca3d8f7b96e0fe1e4e2ac0ed93c20948974b3f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d205a6aaa4c37e4d400890a65ca3d8f7b96e0fe1e4e2ac0ed93c20948974b3f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c06e31d03fc841d664665d75f5c5084aa215886b3d929b9229c7eadd2633f4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4685a70a280a6073ee4ef20d391c336c50fb3af20e3f9aefe24242fc2120f23"
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
