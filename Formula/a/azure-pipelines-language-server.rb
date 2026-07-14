class AzurePipelinesLanguageServer < Formula
  desc "Language Server for Azure Pipelines YAML"
  homepage "https://github.com/microsoft/azure-pipelines-language-server"
  url "https://registry.npmjs.org/azure-pipelines-language-server/-/azure-pipelines-language-server-0.9.0.tgz"
  sha256 "bb67fa7926c2a5b2731dd3e10aceb4f03fd27b9bc16904c9bbf3af0db1e47084"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7202224db6ddf05747a15f68e9aa29987f5572233e57c4a38d689efd23b58702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2704161f37f121d88ec0a500400b70aba9c265a4f791f5ff81c33913e6ce6008"
    sha256 cellar: :any_skip_relocation, ventura:       "de1814fdde3b53831a98aac7db41c8743e927a65b4447b1001e3e883b9b097d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee2ff4d734f1773df77f82f03e0ed42b49287dbd1c74cdcac316c31e6671d84"
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
