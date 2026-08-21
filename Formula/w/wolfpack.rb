class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.20.tgz"
  sha256 "841cf078c72bfe2245ac8737151de9811aa0a2798066388167275303761fbb7c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "37cb84e0bb3d34f7ff67262fbb74dc086b8956f6b71b172f95770c87ba895fe3"
    sha256                               arm64_sequoia: "37cb84e0bb3d34f7ff67262fbb74dc086b8956f6b71b172f95770c87ba895fe3"
    sha256                               arm64_sonoma:  "37cb84e0bb3d34f7ff67262fbb74dc086b8956f6b71b172f95770c87ba895fe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5916d9c31af5c4e33a992f3b529549c6b970bfddea2e6e16b2fe4f8c83f5ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d91527d83032f86eabfbd5f7cd73f66176e1528261416c836741a2c6b8c8ca56"
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
