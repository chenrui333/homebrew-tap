class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.29.tgz"
  sha256 "73b5b99d2fd3b92f9ca21cd91a197fb9c409d6cd4dfbdd95d255ce2d358e3557"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "70e6d1192bac0ec1139cee5926831b5b2629512779a6af55e9d7822557a782ce"
    sha256 cellar: :any,                 arm64_sequoia: "05e6dea99c9cd62e3d85d55a939350662f86c0a43ea9c5a674c04d62e20ee3d6"
    sha256 cellar: :any,                 arm64_sonoma:  "128b24779fbe88ef3c7b6c92d65a0ad78211de57bdaacfde3cea9589dc26e951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "321134b2e77d5b7832bec0e59c4c70fbe747ae418e10415367337d5c6d971c9f"
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
    assert_match "STDIO transport initialized", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
