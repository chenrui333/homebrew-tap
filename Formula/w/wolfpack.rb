class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.3.tgz"
  sha256 "0901bab30a025272c9801543bec4b19053ddb9b510ec036a1eab7abb31287856"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "277942ef90ec6b4bcc9045cd9321a35911029cd0c3f775e8d24032c1e475f51c"
    sha256                               arm64_sequoia: "277942ef90ec6b4bcc9045cd9321a35911029cd0c3f775e8d24032c1e475f51c"
    sha256                               arm64_sonoma:  "277942ef90ec6b4bcc9045cd9321a35911029cd0c3f775e8d24032c1e475f51c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f597fa983abcf353475693786ac3bca1942c80627616b8bc93bf2ef7ddf8cd7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf55979cc8f071f26a4a7b08f80b239ea13a706942ff7bdc427f6e4c9f85b419"
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
