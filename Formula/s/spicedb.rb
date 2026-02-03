class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://github.com/authzed/spicedb/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "3e1decbd59a025cd95fd07c9bbadeef03d72b03af1677114d09b0cc3c41aa1e3"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab59e47f2b382cdb167dfd4334bb8a12c1160b1928c15f904377975d8c7b2c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a26777af3f6e1c625548311caf0fbf5f3295ab33162ec05a555bfac8492771e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c45e2dfb132e5d31a42b2cae13722b12725547bb2b0e888e57887d6878a0deb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32d4e7c848d8320e2e0f7df068229b0dbd7b998099bac71d0c65ea424422e390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f042fc12d82d36dfedc774e6c2ac9d42856263fbf829b205267e03cfbfd26487"
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
