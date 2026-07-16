class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.8.tgz"
  sha256 "19ae61df2318aceb008ac8cd9134b8bdf49b2f0f7e1bd7c50c89f55ea1dafc4d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "8858dc58a3addd6dcfda5d55921292657f799d6b16acdf32df93b2172a368768"
    sha256                               arm64_sequoia: "8858dc58a3addd6dcfda5d55921292657f799d6b16acdf32df93b2172a368768"
    sha256                               arm64_sonoma:  "8858dc58a3addd6dcfda5d55921292657f799d6b16acdf32df93b2172a368768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ce192c295015cfc498990b44b9da3d66b03183ad4c288fff1d9a5f80f795fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c270bc622fea921fca2fb49f0c3e22049e87f8de455c914ded2d4894dd3e5d2"
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
