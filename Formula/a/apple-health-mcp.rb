class AppleHealthMcp < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.1.0.tgz"
  sha256 "78949df6bc376b55f9e5615abfd74955c766b04dcd901c1028821b90219ee16a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "a6433d36fd5e1ef9c33a9a592f8377b5e024a6d7bcf014ac3d9f78f4ad747674"
    sha256               arm64_sequoia: "77201d15b11f1f712d51469dc2bc91e94e4de557acc5e66030a1fe85ec4dd30b"
    sha256               arm64_sonoma:  "091f83308ddf830fe2f48fb2ab6f706d25564c02c32f2bee36e57cb5790c0924"
    sha256 cellar: :any, arm64_linux:   "f90f2024837184e950cbfcd4d9d5ca30a95c4eeac77763c2140bc34619e072b9"
    sha256 cellar: :any, x86_64_linux:  "7a4589bae7e6cd8ff9b3ceeb4cb48b4fbad5aafa835c477a2f8ac56fee95f985"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    ENV["npm_config_build_from_source"] = "true"
    system "npm", "rebuild", "duckdb", "--prefix", libexec/"lib/node_modules/@neiltron/apple-health-mcp"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    ENV["NODE_NO_WARNINGS"] = "1"
    output = pipe_output("#{bin}/apple-health-mcp 2>&1", json, 1)
    assert_empty output
  end
end
