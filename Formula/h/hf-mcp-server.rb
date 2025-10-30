class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.38.tgz"
  sha256 "54cbfde64e6b8e07f884329f54e29216b9313fc09a695bade34b744606444e41"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9196b33e40b67be041628a51b20dccea7e3c3dc22dfff570dfeab2b3f2df257b"
    sha256 cellar: :any,                 arm64_sequoia: "a11d0b1daae29e449e7e4841f13c2848d3855978a30d5eefc4ab45d35c3a8c79"
    sha256 cellar: :any,                 arm64_sonoma:  "a11d0b1daae29e449e7e4841f13c2848d3855978a30d5eefc4ab45d35c3a8c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45a99c636a844d2c79a0cd0f1a36e553ac596edf86f0caec19d382ef12a73db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b9e23e3257cbc02f84bf56c6dc1791d7cb7a9157ea6b4575e5e82575311211"
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
