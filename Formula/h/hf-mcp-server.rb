class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.35.tgz"
  sha256 "274ca3560f78530fb1d3cf56d87910aa694f40a09c6b374a73fb6069298a8ccf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6784563b95a007e44f2e336ed0e6400ccdbd2a27454481e40b86097838ec300a"
    sha256 cellar: :any,                 arm64_sequoia: "c0bf1095f075c3e63e5d5c89d0b7f5e558bf4f36b93e05150fbe05588854f4ee"
    sha256 cellar: :any,                 arm64_sonoma:  "c0bf1095f075c3e63e5d5c89d0b7f5e558bf4f36b93e05150fbe05588854f4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f00492a8b6af0103ff5b463104d132344b76e70367c4509932cb9fb7c9537d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84fbcbf726950fc67ee84eea3ff4d90b804f0ec8234e88167b60980b9dce9113"
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
