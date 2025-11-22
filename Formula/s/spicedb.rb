class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.47.1.tar.gz"
  sha256 "90006029986df17ab35a12e1da0171e04ebf1b3fa254fcdbfc09dc48bed021e4"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fce3737d827271490c7d79067967a777f22a236b724f74e45e1d07395beed9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe66f0e5573af17010eaa8abc67f7d3192528a2903c05100686df3451b33cc11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "361e57e2a5d5f5ef2398a21a6d4f261dd6337c01123da83bcaa76de70d82ebb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b65496a61bf961be44f7874f264c76ce98cf0541d78513eb55392cc4fbfe532d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45ae048c6b9167fa328e10d9a3ff42190fe8130973e8138804d28b4b520ecad8"
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
