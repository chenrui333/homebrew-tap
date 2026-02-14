class Curlconverter < Formula
  desc "Transpile curl commands into Python, JavaScript and 27 other languages"
  homepage "https://curlconverter.com/"
  url "https://registry.npmjs.org/curlconverter/-/curlconverter-4.12.0.tgz"
  sha256 "16b6edc240fc096f09d4bcedf1358c74fb2ea1fd94f18820ef429af98acb49d3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5df8c0ae872dc300a5701f98e9e7fb357967bab58c0cf423b5b05e20c8a7507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3c09d194bfb7d7524a6416fd9b1b504333aecfab5a2ffe51bc660fdbb33b5e"
    sha256 cellar: :any_skip_relocation, ventura:       "dd8ed3609fd323f2cf51599dbdd052ba718eb2ece2c77a80e1dd9df66f36f8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "935bfb5f05622835c2fd6917482c3bd4abf663d2523020ca4eb7b2f7a1fdccc1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args, "--ignore-scripts"
    bin.install_symlink libexec.glob("bin/*")

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
