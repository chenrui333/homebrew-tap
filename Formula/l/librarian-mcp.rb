class LibrarianMcp < Formula
  desc "MCP server that gives Claude a librarian for your Obsidian vault"
  homepage "https://github.com/ngmeyer/librarian-mcp"
  url "https://github.com/ngmeyer/librarian-mcp/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8b9b041be51377f0b9a146f323294529b6fb99b3388b905db458996460c1e1d7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "870fdcdc7dab1f4bb12fbbdb2ebf88eaded9d8cb53d175a38daac45094462c9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d52121336d980fd34564bf45713b55e456c7cc057ead79e010b699544965ff8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6329eeab74e7b814404256af1d64b918f68c547d9997c18db2f0baa0cfd18b3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c66ddd345df1823d311d4202b271b32358a4e94591458de0cb27ffa8f36d8db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e430ddacdd301e3f5408f86d1b7af0553be4e0b6b09799b1f5bf7cbf365d082e"
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
