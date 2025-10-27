class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.35.tgz"
  sha256 "274ca3560f78530fb1d3cf56d87910aa694f40a09c6b374a73fb6069298a8ccf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "07078b6749e3c45865249c8bea80d498070266ee44c035297409c2e46ac79538"
    sha256 cellar: :any,                 arm64_sequoia: "51dc695814aa226c7885fce38eb459488f011fdfa21969628bb9eee9a6656b96"
    sha256 cellar: :any,                 arm64_sonoma:  "51dc695814aa226c7885fce38eb459488f011fdfa21969628bb9eee9a6656b96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1ce951284892f8b68cfeb048251a51bc4eb446ce5033d530574f0b100797469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab2cfde866a6cdf2601662c7bf4c2f526607843fa7f8cad10cc02896d0aa000"
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
