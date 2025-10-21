class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.33.tgz"
  sha256 "4200386eb1b0b049e2dbbac4468fe894ff7bd684dcbdd4070ec8a9bf458ceeba"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ef23969e089be9d2866185a141698c4cfb08f19f5229e1be5a5de5233f1497ea"
    sha256 cellar: :any,                 arm64_sequoia: "88450d15868861ebdf2ff872db38675dbdf8280c4962e71a20b0aee37834ca7d"
    sha256 cellar: :any,                 arm64_sonoma:  "88450d15868861ebdf2ff872db38675dbdf8280c4962e71a20b0aee37834ca7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7137d1ab9942e223f877160734954054d913586575a245a8db1b811103c7cffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd330611282ba5aaa491e7d8b9b7f12619e38caee3a1819a5e301e372e3d5cc3"
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
