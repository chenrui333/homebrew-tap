class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.17.1.tgz"
  sha256 "748945e5aef4251ed89fa557472f7cf93204eba8cb77475cdd38f8099b2343eb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ff2488dd2e10e14522a8aef904db15fa05f3b0a99bc4c4204d392209f0ef96e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ff2488dd2e10e14522a8aef904db15fa05f3b0a99bc4c4204d392209f0ef96e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "519671f36b1374ca67387144e8bd16066fc97c0d63cf674c7e56c092327519d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91ec401d18989fc890291948b921a81292c71cc8b361db150f66d1ff31d2772b"
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
