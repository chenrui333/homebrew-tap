class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.49.2.tar.gz"
  sha256 "375343717e81ace4108aed7442a6a0827a5b404f00d66a8527f37ca6e610c029"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cb8bc7d8c12e10fbc044ef666f0e42c9bb6148c86aa94dea6431c328c39c0b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c43f0f993b64c39f0fb5746a83e0da7e45e4c040d8cc607d7264ec98efabefbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c68096124f8269dcf8c6e65e1c3c56495ff749db3af519baf3162564e3812047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd6d240831049d9bb307e09dc93c1b14d71262b8feb36d19653fe1c66bf8579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ecc089b7f0579d36dae1d229fc91029d847aa606185368be649a64cc1acfad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/jzelinskie/cobrautil/v2.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spicedb"

    generate_completions_from_executable(bin/"spicedb", shell_parameter_format: :cobra)
    (man1/"spicedb.1").write Utils.safe_popen_read(bin/"spicedb", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spicedb version")

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

    Open3.popen3(bin/"spicedb", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
