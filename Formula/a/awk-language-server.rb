class AwkLanguageServer < Formula
  desc "Language Server for AWK"
  homepage "https://github.com/Beaglefoot/awk-language-server"
  url "https://registry.npmjs.org/awk-language-server/-/awk-language-server-0.10.6.tgz"
  sha256 "254c12fefe25453846313318fcd5f7b00dcef46568bb02c065a65248a77d3e11"
  license "MIT"

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
