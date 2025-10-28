class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.37.tgz"
  sha256 "b878b90e40fd18acc912a98cc5a2a87a1193b95129292f2ff7b9b6181b75b4e8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2ea75075731d5cc90e5ecc99478c2e46e2e46c2960cd3323266c21cd6a7812ee"
    sha256 cellar: :any,                 arm64_sequoia: "2cc7ee3e2021ad83cdd3c23b58e6c5981fd59474469eba253589c052758a52e9"
    sha256 cellar: :any,                 arm64_sonoma:  "2cc7ee3e2021ad83cdd3c23b58e6c5981fd59474469eba253589c052758a52e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6dc21f33c74639035cf0324716edc75baf03d4da6cc01e72544e21323c37fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e083c92801a9fd071fa5b112f003ec862c5295eca63608667ac37720b764d350"
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
