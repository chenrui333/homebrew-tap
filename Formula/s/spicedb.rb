class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "138efe3e6c8ac6cfa4dc3ac00708146201c7013047481e83f40cb089c38ca0e4"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6798f75a9b59359cd7dc92ef5b8123e8487502978bbcbeb953c5f693f0a13ba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fceb674da2b1c4af1e245c063a0354961cc5f2c57eb7490ec157543f27d47cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d0e00617203592ad8bd051e9c6070c107e94c16c476fd76e9fc1215885dae42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c14dba947ebc0f98b4d29546a09a5cba65b72349fb87a40c25b8e66680990ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9f48597b7366cfad927373b0682a00722baa76b9d0a7ada4ef756a6fb43b4c"
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
