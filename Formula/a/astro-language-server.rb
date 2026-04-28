class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.15.4.tgz"
  sha256 "c7d463c40c488c0315056cda65c50299db3cb57bb155a6429d32f184688529db"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7211db9215573ddc42b0210d1d1d8d825df388816a8c9801e69c66ac0ab8bcf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06b589700e8ae5b3dcced1429b9f3930b77204640ab8e699dc2e3c02bf9ccf1a"
    sha256 cellar: :any_skip_relocation, ventura:       "e7e18fbdd9a5aee4ec3d30df975ad5c8873a68160adc1c6493a494fe9207bf25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a13fe15da302e9cbe0641070a200d1bd765b14c84a35d6627e559b9fdd51ffe"
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
