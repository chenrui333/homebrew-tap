class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.16.13.tgz"
  sha256 "d889834a4e1dacaadccc481d05509180219ae4c0c0e0a44d952ddbf03d2a49ee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e7206e9e2ec591333880c4304fbeeecba8bc3bf21568d1d3c6836c4c2e27cd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e7206e9e2ec591333880c4304fbeeecba8bc3bf21568d1d3c6836c4c2e27cd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e7206e9e2ec591333880c4304fbeeecba8bc3bf21568d1d3c6836c4c2e27cd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53b3664bfebff6ec2786886766419a5a6f32ee3486237710d707cc98bad8cdab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7894c48a920fb90af7b2d934984ee8710c20eece505213f14344ca1e0c6fa988"
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
