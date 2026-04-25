class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.1.tgz"
  sha256 "2aaac8765a6a4b366533bccff03d3b6135acff8fa40a655ec3f7a99005a14899"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1c216e74be07496f4eeebc91b94b9df6e2f3e1b616b57ef4a8547807ce89eabf"
    sha256                               arm64_sequoia: "1c216e74be07496f4eeebc91b94b9df6e2f3e1b616b57ef4a8547807ce89eabf"
    sha256                               arm64_sonoma:  "1c216e74be07496f4eeebc91b94b9df6e2f3e1b616b57ef4a8547807ce89eabf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce7af71c4d203145664b8003a0673466b98405b765ebb582243e85d84c580fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11a403238052d5353522397d1219ed5acd9cd5d8a0276ac601cb2c07df2426fe"
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
