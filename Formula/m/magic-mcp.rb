class MagicMcp < Formula
  include Language::Python::Virtualenv

  desc "21st.dev Magic AI Agent"
  homepage "https://21st.dev/magic"
  url "https://registry.npmjs.com/@21st-dev/magic/-/magic-0.1.0.tgz"
  sha256 "3bd43e9ecbc55e9dd1d55c7760f3e57f506624d7c73337899dd7329ac6fd74bd"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c61024258d7317de40410d8207edbc0ff8cb54a3a375b60c084b81a538f48251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32d5c99a183f5adb12819f178e6fead3145793a4c1be679458e1f321d7c160d6"
    sha256 cellar: :any_skip_relocation, ventura:       "ac7a94560d22e202cadb1077b7db1edec0645ce1711ea0597905cc1e53f4c534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c49d0b05b2c541a68c859047a1da5d51c9840211aa2c9cb3a916dd57a7eaca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
    mv bin/"magic", bin/"magic-mcp"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"magic-mcp", json, 0)
    assert_match "Use this tool when the user requests a new UI component", output
  end
end
