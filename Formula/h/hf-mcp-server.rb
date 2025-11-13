class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.44.tgz"
  sha256 "db42b7c13fc0593a1048566f6446a3c042b5d406b1e0f9163463d1d7e0fb3254"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "fbd73eb2b6c4bd5c01270bc7ee5951ab70e2c4867a7c78e87a58d29bb7117354"
    sha256 cellar: :any,                 arm64_sequoia: "f3bc3ac4e0980600f523c3caeb456ef7e916f4183e8ed3351c20cd939a216ef6"
    sha256 cellar: :any,                 arm64_sonoma:  "f3bc3ac4e0980600f523c3caeb456ef7e916f4183e8ed3351c20cd939a216ef6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "101551535ce07c206d7e0c3c860e0de865dd45b0f74c32e0a1f60c1da853d9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "510ec068449bf0f20cd28060cc56a685bdf8a6565493d47be26b3a3a3b467305"
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
