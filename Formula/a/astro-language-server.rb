class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.16.0.tgz"
  sha256 "b0ac349b6d28136742e4f8737080821b3a40d818be0d98e44931e2323aee434a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16fded3d525e922f581384eff1cadbaf60ef024fd9632e20ed2b72b2af71ee55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e4499897f17fe5d0c0d9fe80c328adb15066dec0db238f1253cb3206072e16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b3d22cfbf1139abdcb0651ed4654f0d790f1c0ec2a86bad952d0cf366800f7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0445c3b4d9d8969e4eb7cad03df12e2677091fdc3b9249922028397234ee29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27ff243f65946bad746ffc361a466649c61f1df8000835a528c9d59d41c4177f"
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
