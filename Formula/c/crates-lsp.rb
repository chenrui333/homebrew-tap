class CratesLsp < Formula
  desc "Language Server implementation for Cargo.toml"
  homepage "https://github.com/MathiasPius/crates-lsp"
  url "https://github.com/MathiasPius/crates-lsp/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "2310fb041b229cf5f2bb4d4bc88826a27e3d27b4fbdc5f2597dfe73e26be59a7"
  license "MIT"
  head "https://github.com/MathiasPius/crates-lsp.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"crates-lsp", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
