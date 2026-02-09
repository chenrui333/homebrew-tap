class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.49.1.tar.gz"
  sha256 "5dcf982681c3fe20dfd391ce5adbcf26fbc3e6b083b855efcc61fccba7de292b"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "988bd92b8f2067823b531d62f0813f91652cd2758bab90f0e873b370dd0bd442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c72b581d8a63e22171c4a514cfbc29ad1f7684eb51c82f3a70fb48c1aa90457"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d83e11d88131ff7278c08716845c63ff0b995fd0adbf4d22996af419e256cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8b933eddfee1cf9c2625b891458918a88ae57e32a689883dd7761b4842ef679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8e4add67b061bd20af2555527ca003a792f9c76026becc8df92c0e814735a0c"
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
