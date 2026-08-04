class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.14.tgz"
  sha256 "262452be5b63d078904e08ce1eaa079055d02c9a23cd0ef9da7181cdac9f3060"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "9df446ec8f6101fc78df4b3bf3b36f9277aebc05f2dbc4d5cdccd599d3392fc8"
    sha256                               arm64_sequoia: "9df446ec8f6101fc78df4b3bf3b36f9277aebc05f2dbc4d5cdccd599d3392fc8"
    sha256                               arm64_sonoma:  "9df446ec8f6101fc78df4b3bf3b36f9277aebc05f2dbc4d5cdccd599d3392fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d92c472abde89be96bf1280ddeb4103138a577061abc77a59ee1f6412eaa0df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "157b2deeffee50810bbe8f521bec97c2edd37034c07a87efe23a5c897acbabf3"
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
