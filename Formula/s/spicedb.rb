class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "2b8cf895b86989b01a2079aed4160b0a899766367e1c50e476002d4c7bee5cc0"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6f27c8a37e3edc14c81df1310246e40413247bce7b14465851d8a65a01063d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a752ee0e9e23d7f665eefc609dc878fd45545bb727f4ac44cd24d99421b856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c959caf8110aeec3905b61b44fc8cc4bc970b41e946f2f3df9520e011b967709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08b26a05d0395536bf6618bc2d6398e610f31899b8b5c279691d15a4fdff1145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e57950b40150c038f0eb0234890db90fb1c7d0d2835b7c71ea253b3ee74e8309"
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
