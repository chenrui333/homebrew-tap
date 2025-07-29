class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "1c74c8e403ee572a323397032d30b4b3ec2332c92941764714f1bf221b78b022"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "979746664673fb2bf5a330f25c21468c5f537bd7a6d04a6d7298521417daaaf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edcc3870fdf02c72dc623cb5fec0bebf41fef60b3dbb0b27fccf9a6e9d2f92f0"
    sha256 cellar: :any_skip_relocation, ventura:       "45100e0c7c63a17053ddd187b542970ef88e97e3cb58d108342498e260e0e9d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d1bfd41095ee0fd93e54977c31848b057e785e662d98ebd561498e3a555929"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
