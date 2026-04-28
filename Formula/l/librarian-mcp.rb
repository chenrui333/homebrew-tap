class LibrarianMcp < Formula
  desc "MCP server that gives Claude a librarian for your Obsidian vault"
  homepage "https://github.com/ngmeyer/librarian-mcp"
  url "https://github.com/ngmeyer/librarian-mcp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1e93fae534c93621f0e9f298f56241f0ca5998a08f4d25a0975298daadf6ce38"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/librarian-mcp --version")
    assert_match "Give Claude a librarian", shell_output("#{bin}/librarian-mcp --help")
  end
end
