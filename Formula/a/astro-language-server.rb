class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.17.0.tgz"
  sha256 "4a141105ecc1860a834c596730ec5efe8d7009a61b01f84ef074a1d0fe30ae69"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8c8979d8114b871a15f4e53208817a134806051f66ebda329c6c450a03985d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8c8979d8114b871a15f4e53208817a134806051f66ebda329c6c450a03985d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2375856ab55500cc10e87747a4303733d39c1aae9739883147763ee0690309c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3a00951b093e90ceb69566bfc9b4d1e86c44db84ce30fcaf444c383ed426d53"
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
