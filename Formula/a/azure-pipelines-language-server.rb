class AzurePipelinesLanguageServer < Formula
  desc "Language Server for Azure Pipelines YAML"
  homepage "https://github.com/microsoft/azure-pipelines-language-server"
  url "https://registry.npmjs.org/azure-pipelines-language-server/-/azure-pipelines-language-server-0.9.1.tgz"
  sha256 "a0726c5ce93de8cef7c2aa0ea713826c5c2b2074a4c538d50b4025014d5dd1a9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "34132217541136d3bd2fc01ba900fdb4cc519d9278f7e35e5ebba4b9468ec0df"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/azure-pipelines-language-server"
  end

  test do
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

    Open3.popen3("#{bin}/azure-pipelines-language-server", "--stdio") do |stdin, stdout, _|
      stdin.write "Content-Length: #{json.bytesize}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
