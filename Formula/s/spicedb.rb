class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "2b8cf895b86989b01a2079aed4160b0a899766367e1c50e476002d4c7bee5cc0"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a433a07f6a0e6f15f9baa85aa32241fd4f15b1e920c258745d987d9e3727bb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c62885ecd16e4f91fc8da1ca8c5090e2b605203002e7c01dee67e32b55a7889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "551fe6b80e2df8250eb897cf1bed77837214f71ad74a839bcd257eebcb2c12d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da8e8668e6b1bf0e8f79df43c03fc739523c4debcf6575fe9684d18c0d8ff9f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d70b901462abc80cbc045e210ab73840fe0e6742ce0cd1bf229014a1926c5f3a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/jzelinskie/cobrautil/v2.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spicedb"

    generate_completions_from_executable(bin/"spicedb", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
