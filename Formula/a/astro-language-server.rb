class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.17.3.tgz"
  sha256 "4b8e4a98e6aeec0ee72e4db4cdf0723da28994efc6cb371ac868ea777f019f88"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8376433d5e235a20f11b6efc8714e87f75788bb319196a4ae74fbc8ebbfbd01d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8376433d5e235a20f11b6efc8714e87f75788bb319196a4ae74fbc8ebbfbd01d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dab865c5ae3c6d1c6b494fcc8cc96e690e02e8f8471f016e13bddd341f16ad0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb5dd0ee8d01b7dd6d047479642bd79d36d2f752ba895df3c5ebf9c7ce62d37"
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
