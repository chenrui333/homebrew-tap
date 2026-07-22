class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.16.13.tgz"
  sha256 "d889834a4e1dacaadccc481d05509180219ae4c0c0e0a44d952ddbf03d2a49ee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89632aff75f4cd6840f2077ac09123f7ddf7b016391760c72193d24d59387241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89632aff75f4cd6840f2077ac09123f7ddf7b016391760c72193d24d59387241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89632aff75f4cd6840f2077ac09123f7ddf7b016391760c72193d24d59387241"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15123fd41fa9d377b69f58e91d29ff8d0fdd4cc7acabd2f19ab240e9f7c4a81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69736c74026d0f54eba0c7c80a9aa9c3879207784df3723464b17c849d6368f4"
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
