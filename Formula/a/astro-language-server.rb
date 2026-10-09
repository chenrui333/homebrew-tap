class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.17.2.tgz"
  sha256 "8dfee20ae7ccfd0b7aaee77ce24ebb8d45d801eecef970561ef68564bba71d7b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c393794a0382a2262a5c31f263c2d76e5e29af6ee4a87eaef2c75f609a2cf87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c393794a0382a2262a5c31f263c2d76e5e29af6ee4a87eaef2c75f609a2cf87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be0f7a23e30935fbef869e26b101a69c5cfbdaf63cd6c9f8e7f37ae1c97343e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "691fa52a2de858bf6249411a14be9097dc599722c819f0a3c165d65808d0de59"
  end

  depends_on "node"

  deny_network_access!

  def prepare_package_json
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devDependencies")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    prepare_package_json
    system "npm", "install", "--offline", *std_npm_args
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
