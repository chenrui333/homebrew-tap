class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "23702832ed0e91634187acc5cc1e8ccd87d17fc3d8e432983b6bf47c8a93066c"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4c348807ab16cd36e0d9d2c0625bc8b9bef7122ff9de1fa938866929732bce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4c348807ab16cd36e0d9d2c0625bc8b9bef7122ff9de1fa938866929732bce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4c348807ab16cd36e0d9d2c0625bc8b9bef7122ff9de1fa938866929732bce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b54323fe13833dcf80fa023b5f40bd4e09cb476e2b287d67fe24e1813f6d2131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "183ac99a5a3ed68e670aad448090295740f97cd661026cabb120d224170351d7"
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
