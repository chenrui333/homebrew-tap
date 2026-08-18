class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.19.tgz"
  sha256 "6047d624be9d8da03980dd4e3ed967215a760270b4492c8fb702bbe1ee16fba3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "473b7223be65b0faeab3f472864a657792ecb341cd71a22116cb087a43613b08"
    sha256                               arm64_sequoia: "473b7223be65b0faeab3f472864a657792ecb341cd71a22116cb087a43613b08"
    sha256                               arm64_sonoma:  "473b7223be65b0faeab3f472864a657792ecb341cd71a22116cb087a43613b08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4d5e82404b10558c008babbdede8856ffbcd916ba1498d95e4b13cc4eac609d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "627676c7f2eb1d42b5b58bb859c27212aadee4bc9e6938837add35f00c6e354d"
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
