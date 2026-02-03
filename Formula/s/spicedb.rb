class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "3e1decbd59a025cd95fd07c9bbadeef03d72b03af1677114d09b0cc3c41aa1e3"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f593d0221eb9c06446b750a0312302e5c7e453bb84d756e7898d9d9ce9779c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "395b3f576eff5085d6035a1c25038f13b9ade26f63fcd36b104a440762d7f66c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d141ce29ba03657009155a3f0d1384a62ab906c5f4c82727a6272537ee65332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "202035ec565d1705e8632608d92ee42cadf8eba85f3537044cc01153a2f77be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "684d2687a7bb4584be4566096224ff5876d4bfb24f3a7538f7dcc2878a782e38"
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
