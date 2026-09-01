class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.16.16.tgz"
  sha256 "3b260664aaec5169d5b4ddf93e6500eb27e3f6824242f1f94e69f193188ae031"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be76609972a0f3cf70ca4a7ab40689a23c38e20cd361193a0e4fcdc6bb252c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be76609972a0f3cf70ca4a7ab40689a23c38e20cd361193a0e4fcdc6bb252c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be76609972a0f3cf70ca4a7ab40689a23c38e20cd361193a0e4fcdc6bb252c49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd401577c0e418faef0e26e9b04b5964dd0f3add8d9a3e409a0c3dd739c9bff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3b1d3f4cd409c15107260674c9eebd72837429cf27b051e3dc67c684e8e914"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/astro-ls"
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/astro-ls --version")

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

    Open3.popen3("#{bin}/astro-ls", "--stdio") do |stdin, stdout, _|
      stdin.write "Content-Length: #{json.bytesize}\r\n\r\n#{json}"
      output = stdout.readpartial(1024)
      assert_match(/^Content-Length: \d+/i, output)
    end
  end
end
