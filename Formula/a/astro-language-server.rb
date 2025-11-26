class AstroLanguageServer < Formula
  desc "Language tools for Astro"
  homepage "https://github.com/withastro/language-tools"
  url "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.16.1.tgz"
  sha256 "bebdb39a92db0f608bbf1acf74e3c3b0da1f9185c8a0b016d51ca40e6cc88e31"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "613096984512800f598bd0f838c8a5f0ae800bb31dedf60cea1b99f84a700315"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "569cab91532ce7ee6dd80514a7adb5fbf5f6fc5b63e0f7d686b20ac66bff9c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9da93bca140ca6c1af64eb601ec283f7411ceee8d908aff935a7e05b9b55cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b89d4081532e22de83a2453957a8cc0c6838938214977e2cd3b0e6ef784d9d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76cf5505db3d05408b636407fbf5a484ef7823c9b81bdc5fb9d8705832f3f243"
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
