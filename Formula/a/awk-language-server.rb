class AwkLanguageServer < Formula
  desc "Language Server for AWK"
  homepage "https://github.com/Beaglefoot/awk-language-server"
  url "https://registry.npmjs.org/awk-language-server/-/awk-language-server-0.10.6.tgz"
  sha256 "254c12fefe25453846313318fcd5f7b00dcef46568bb02c065a65248a77d3e11"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "6c776ef4f0b9ddebb1124be27c879baf20d388b7caac6664dc96feb5c41c254b"
    sha256                               arm64_sonoma:  "84d80d9e0f3befc847dda468209c83e91586b13c5c47205aefb895b9291784c2"
    sha256                               ventura:       "9d75a56c81ecaef0e0ee16d8d01d15223e838568a5a56c3f8296f8d56bc116b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b23fd47665feaca5a7a5e950a9d995d84f6f309b9c8b637f3e6542329dbf35e"
  end

  depends_on "node"

  def install
    ENV.append "CXXFLAGS", "-std=c++20"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/awk-language-server"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/awk-language-server/node_modules/tree-sitter/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awk-language-server --version")

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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/awk-language-server start 2>&1", input)
    assert_match "Language Server is started.", output
  end
end
