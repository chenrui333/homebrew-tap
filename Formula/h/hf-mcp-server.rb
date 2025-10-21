class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.33.tgz"
  sha256 "4200386eb1b0b049e2dbbac4468fe894ff7bd684dcbdd4070ec8a9bf458ceeba"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "81e80814337a24f9e76e7b82825f51a4231f5eb6b2f710584575826afb89f72d"
    sha256 cellar: :any,                 arm64_sequoia: "750b504d241b7686d08bba29927de7a444ad633d5b7695c555a050f620147a05"
    sha256 cellar: :any,                 arm64_sonoma:  "750b504d241b7686d08bba29927de7a444ad633d5b7695c555a050f620147a05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e952fcadab422ce1c89c699f1b8edd26ce06782dfd1ab272cd350b528ae9bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47c0ca0b46fba247dce2756c483d40fb032da533fe4461412bdbcc09613290d"
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
