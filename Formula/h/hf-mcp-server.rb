class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.38.tgz"
  sha256 "54cbfde64e6b8e07f884329f54e29216b9313fc09a695bade34b744606444e41"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cd734e44ed6f5d648e6036d9371543dc475d96a0ce54b7f499a336272da19056"
    sha256 cellar: :any,                 arm64_sequoia: "9c1e51eae19f4e6d7466b3354aaf5bbebe36f92b59c06b16807e52c4e8d53643"
    sha256 cellar: :any,                 arm64_sonoma:  "9c1e51eae19f4e6d7466b3354aaf5bbebe36f92b59c06b16807e52c4e8d53643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "149a604bc9873ab99665417b10f362e609483f6104ba2c78329a540af07a8ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "772bd8e86838f68ee70eee5dc7a205b76fe54553c83b3e43ac8b6f8bddc7eb43"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
