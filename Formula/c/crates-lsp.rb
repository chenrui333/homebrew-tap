class CratesLsp < Formula
  desc "Language Server implementation for Cargo.toml"
  homepage "https://github.com/MathiasPius/crates-lsp"
  url "https://github.com/MathiasPius/crates-lsp/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "2310fb041b229cf5f2bb4d4bc88826a27e3d27b4fbdc5f2597dfe73e26be59a7"
  license "MIT"
  head "https://github.com/MathiasPius/crates-lsp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89cdc28e5060d974245648cd9a77d307c03ec04cca061f0e26b591499e281e71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3368f85935e646cf90326149aea4461535b43c0bcab6bc739b584f7e678be37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f1dc4274ce622669a991eda110a6ab7b603f36ea6b679c9e40b588b30f7a023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "371cecf44fd0459ac27ddef1e535c8498bd3852d4eaca20a9c368b58c32fd429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d2a7807af17b1857a9a231af18944f4f66e0cdf13b8ac6c995681152ffb8f9b"
  end

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
