class LibrarianMcp < Formula
  desc "MCP server that gives Claude a librarian for your Obsidian vault"
  homepage "https://github.com/ngmeyer/librarian-mcp"
  url "https://github.com/ngmeyer/librarian-mcp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1e93fae534c93621f0e9f298f56241f0ca5998a08f4d25a0975298daadf6ce38"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "734736cddf081fa8b5589fdacc5abdb6b6dce9c48b9d6014d34794e84dcd3054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eadb559a8e3c328eb167d07f2af74cdf5526eccbd8023c96e90f33c7ff575eb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea5ee60c6f7630e1cf906d94fde87321887e2789805d2c9de48924a746959e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e5e8c0740e649775fe85dbbef529adab51b6b32e6a0cc975d6756a36f89dd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e663ffcaa71f77d505a3eb592676a1d5b5a55edad2ad6dfa4239f4c2162e13"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/librarian-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"Homebrew","version":"1.0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/librarian-mcp #{testpath} 2>&1", json)
    assert_match "library_search", output
  end
end
