class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.18.tar.gz"
  sha256 "e83e8edc8152c3d9053eb09b373bf2688f9e0dea5696ad0d19870b38bcea780d"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "335e6d22b57bfc71870d67e53ee6da2f6c062ac993618124154ee49f5a6ad8d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "335e6d22b57bfc71870d67e53ee6da2f6c062ac993618124154ee49f5a6ad8d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "335e6d22b57bfc71870d67e53ee6da2f6c062ac993618124154ee49f5a6ad8d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "923477c55537f388fb12cea182362509d50a865ca329833d56ad4b5181154e95"
    sha256 cellar: :any,                 x86_64_linux:  "44062fe867d44b15ccb25d8c61e0a0c9ebbfd106359f0cb05ba18c997304033f"
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
