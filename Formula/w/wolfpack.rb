class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.3.tgz"
  sha256 "0901bab30a025272c9801543bec4b19053ddb9b510ec036a1eab7abb31287856"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0058ac7496a0c11f766730d222fd7708495390ff2dacc44451e57dd1c46cb1d5"
    sha256                               arm64_sequoia: "0058ac7496a0c11f766730d222fd7708495390ff2dacc44451e57dd1c46cb1d5"
    sha256                               arm64_sonoma:  "0058ac7496a0c11f766730d222fd7708495390ff2dacc44451e57dd1c46cb1d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "897f67033fc2d9282f18097c915bbf5ee6e36454a193493b78a026e04ca4c256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66bc97d96fc42545be8e8a86ee9d45ac39e38631180cebdb0a358e4bc118b385"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    pkg = libexec/"lib/node_modules/wolfpack-bridge/package.json"
    output = shell_output("node -e \"console.log(require('#{pkg}').version)\"")
    assert_match version.to_s, output
  end
end
