class LibrarianMcp < Formula
  desc "MCP server that gives Claude a librarian for your Obsidian vault"
  homepage "https://github.com/ngmeyer/librarian-mcp"
  url "https://github.com/ngmeyer/librarian-mcp/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8b9b041be51377f0b9a146f323294529b6fb99b3388b905db458996460c1e1d7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d882077f37434f85af649b93dc922b7d706597e3bd9fb26af43d6f288e704cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d897f767195f071b593b1494d93a3c74642b7acd6edf0d5305fc53bf7240607b"
    sha256 cellar: :any,                 arm64_linux:   "759ae70c557bf795030ac2e580fe6ad1b01ff2577fad7780473b63ac5e4eae8d"
    sha256 cellar: :any,                 x86_64_linux:  "1d3db5e809b397589569ea02f56cf9aa93b764a045673ba89a48a5b56f74fc32"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
