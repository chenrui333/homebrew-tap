class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.4.tgz"
  sha256 "000be831f31e4e87a5417b0cc9a2a7cec3d6e134e0d241e4aa9c039010d09e06"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "177b7c5f164fb01380df377d453d33b7cf6f7978139d3656cf06751e68039d9a"
    sha256                               arm64_sequoia: "177b7c5f164fb01380df377d453d33b7cf6f7978139d3656cf06751e68039d9a"
    sha256                               arm64_sonoma:  "177b7c5f164fb01380df377d453d33b7cf6f7978139d3656cf06751e68039d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b026aec666d43434122552de3f44fff4697f2395dd1595faa23348beb02f6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b091e52e1cf28b07dc44ce1b4d848c061374a1ebeea17966bc66eab71b690cb7"
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
