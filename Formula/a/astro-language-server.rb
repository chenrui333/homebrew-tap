class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.16.14.tgz"
  sha256 "a01ce75357fc92fab47910a5abe05afc27f1f8e099378b8a1a71efb49ea5c2fb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd6b3a5400298dd01d4f1c6c5961966225a17ecbafdb7b0bf81bba752a5702e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd6b3a5400298dd01d4f1c6c5961966225a17ecbafdb7b0bf81bba752a5702e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd6b3a5400298dd01d4f1c6c5961966225a17ecbafdb7b0bf81bba752a5702e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a29d2c94e07688ac7f6aaf2a51f70215cc3b22eeef2999a4813d03d6aa12d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade4455b203e545460ea1bdaf8caed95d68ce9d17a4de618c7b4b2bd299a1ac4"
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
