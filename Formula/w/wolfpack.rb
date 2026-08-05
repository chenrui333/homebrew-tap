class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.15.tgz"
  sha256 "6f3ea76ebbdf608d1704a19d212957cc2d4bf67cc86335a4222f656a90414c43"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "bc456c16455454c8518305f8ae83d1b01796cab68da7369c3c54c04357f44ba0"
    sha256                               arm64_sequoia: "bc456c16455454c8518305f8ae83d1b01796cab68da7369c3c54c04357f44ba0"
    sha256                               arm64_sonoma:  "bc456c16455454c8518305f8ae83d1b01796cab68da7369c3c54c04357f44ba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d01d5cb55701785a1a38e6e8598d32bc920ea3380d23101e32c4810deefe1f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf78b3cc836e3c14a01936580b85fe882282a6addccf23b58f263e34f4e7fbce"
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
