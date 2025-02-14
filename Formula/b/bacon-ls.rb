class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.16.0.tar.gz"
  sha256 "db782e4c79f8aeeec9370bd10a986a991e0929055ce92baa0dd9a4847c171590"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae72523e4bd75a023aef060f811877a220dac9c825d77de707424acea66738a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68ffc7c00352043db506f31f5fa55db40242751eedc86745dd8e2dc436d86bf7"
    sha256 cellar: :any_skip_relocation, ventura:       "8fa810d889cd4d10d786ca107cd172003473c3be61d27f870936bd2846a80ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920cd01dc100196ddf26399453d5db2b9f60e337a6c2b56e16735e29086eff66"
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

    Open3.popen3(bin/"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end
