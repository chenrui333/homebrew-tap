class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.16.0.tar.gz"
  sha256 "db782e4c79f8aeeec9370bd10a986a991e0929055ce92baa0dd9a4847c171590"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91dc8a3f3cd5addd65a801c58b868d85cc8de298594563a3b475e9de91b35f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da746058ce09b540d709533c390fc50d4e0bbec34e2df485cc3020981366700d"
    sha256 cellar: :any_skip_relocation, ventura:       "b80329abbc4dfeadf028c79de44e4395cf862b58f65393dd3fbd569d1ae77d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea5be7eb9754de173e7ff952bcb4e6b86b0416ddfe4e70d5ed22b8767554b279"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/bacon-ls --version")

    init_json = <<~JSON
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

    Open3.popen3("#{bin}/bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end
