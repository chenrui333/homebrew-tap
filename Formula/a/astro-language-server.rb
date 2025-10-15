class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.15.5.tgz"
  sha256 "8ea2da9e176023ed414ae36863e2edcf72486fd1ec6b4740893e0d231dd4f409"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6586af88e278b3865f61efca328d30db192ae24d2b2f6cdacb9ab8baee4d69ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "811328b9984614b5552f08fdc64fca61ce7bbdc057db0d56ac0c3b008d0b7de5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb205007a6a049027731497e082d6c942e83de128f6438b146a7e311ed5c7a44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf574b4880d102f3f9a775784a185df31f2592d3045e1b316fedda7263f6ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53247a7553c491b455547a343c782a750403ff2442864af12ecfb2222ef284e2"
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
