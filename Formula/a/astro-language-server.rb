class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.16.15.tgz"
  sha256 "ff87b5aaa82b0c213bdc946619d4d456ec8dd9685704f0ef7af1b113ea78200f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8d8ab6bbdf00331056653c858518a605d86b006b6ab18dbcc605136132725c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8d8ab6bbdf00331056653c858518a605d86b006b6ab18dbcc605136132725c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8d8ab6bbdf00331056653c858518a605d86b006b6ab18dbcc605136132725c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5204f9dec479b57c0e72d1e8144120c5df1f6d32429dc51d4a18d603862b5414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4641596334de82b183aa2a9bfb6049c40fc8b694addda46bd38ee5aeaa5232e3"
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
