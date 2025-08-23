class Curlconverter < Formula
  desc "Transpile curl commands into Python, JavaScript and 27 other languages"
  homepage "https://curlconverter.com/"
  url "https://registry.npmjs.org/curlconverter/-/curlconverter-4.12.0.tgz"
  sha256 "16b6edc240fc096f09d4bcedf1358c74fb2ea1fd94f18820ef429af98acb49d3"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args, "--ignore-scripts"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/curlconverter/node_modules"
    node_modules.glob("{tree-sitter,tree-sitter-bash}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/curlconverter --version")
    output = shell_output("#{bin}/curlconverter --language python 'curl https://example.com'")
    assert_match "response = requests.get('http://curl https://example.com')", output
  end
end
