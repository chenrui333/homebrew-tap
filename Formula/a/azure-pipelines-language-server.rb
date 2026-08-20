class AzurePipelinesLanguageServer < Formula
  desc "Language Server for Azure Pipelines YAML"
  homepage "https://github.com/microsoft/azure-pipelines-language-server"
  url "https://registry.npmjs.org/azure-pipelines-language-server/-/azure-pipelines-language-server-0.9.2.tgz"
  sha256 "144bab396bebfa3a3da143c5f039af0b384e115c136e1a0bf8dd15c02a0c6e5c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "e3c39c0bd1bc42c5492189410af36879f7a4807be3d59199372bf885541c34ea"
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
