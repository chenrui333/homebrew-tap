class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.13.tgz"
  sha256 "1c770f810c6400328902ce1b673f41525c80b736deaec8afb3c65517aded54f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "261ef1c68d621dce0619ac8593fcccd63602d2ba29a3ab5b99d0a43da5d9f246"
    sha256                               arm64_sequoia: "261ef1c68d621dce0619ac8593fcccd63602d2ba29a3ab5b99d0a43da5d9f246"
    sha256                               arm64_sonoma:  "261ef1c68d621dce0619ac8593fcccd63602d2ba29a3ab5b99d0a43da5d9f246"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dffb01719e3cedbdb4655d8c6358088d280c1f66cbd294eac2aa2dd00c50509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b92579153d73a99efae0e68b1d332d12bd49e5970b15b7f9a3b97623ae65b5e"
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
