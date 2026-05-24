class LibrarianMcp < Formula
  desc "MCP server that gives Claude a librarian for your Obsidian vault"
  homepage "https://github.com/ngmeyer/librarian-mcp"
  url "https://github.com/ngmeyer/librarian-mcp/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "0e96c702c43f90551a185ce91e0fa360942c55858d91ab2732f2f1d5268c710f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df425287bd7b80334b5bdb7a9d1bf622a87caa2e52075afba6f9a797131b082d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db12ce3148ec49734be431c2a566a48ab7f09b0e7d94d15069bf86fee3d63ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f494ae4041a97e4609fe48ababfdd3a0808bbcd14c31b0394bcd54492f0cd26f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2715647b81b373907de42c8a20ec896edb6736b37008fea46d3d4b21290b668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3136a64097565e997fe00f804e50e4111dff7a1c40ef139682192473be44443"
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
