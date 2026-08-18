class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.19.tgz"
  sha256 "6047d624be9d8da03980dd4e3ed967215a760270b4492c8fb702bbe1ee16fba3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "776f759b1c87e607be5c864b7381cec2c63e85bba9b1fc89d70deb4a80a0f9de"
    sha256                               arm64_sequoia: "776f759b1c87e607be5c864b7381cec2c63e85bba9b1fc89d70deb4a80a0f9de"
    sha256                               arm64_sonoma:  "776f759b1c87e607be5c864b7381cec2c63e85bba9b1fc89d70deb4a80a0f9de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35b04ee9b4e024dd4dab2b7287fabaf3882806fe8555404cbefa211e4dfa4975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a13515662a5badb38fc9a2b6a1126462826e87a7acc8532e4a39a095cae75f6"
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
