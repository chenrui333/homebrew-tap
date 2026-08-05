class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.15.tgz"
  sha256 "6f3ea76ebbdf608d1704a19d212957cc2d4bf67cc86335a4222f656a90414c43"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "9ec3037bb39ae0c5ac69031229220b0ef0ebec0a5dd0030ad69a2fe7e6206151"
    sha256                               arm64_sequoia: "9ec3037bb39ae0c5ac69031229220b0ef0ebec0a5dd0030ad69a2fe7e6206151"
    sha256                               arm64_sonoma:  "9ec3037bb39ae0c5ac69031229220b0ef0ebec0a5dd0030ad69a2fe7e6206151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4181959cad7699b0ee9f45c20c4291b684fb915a5f356e71f07b94944c0a2eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb6273ff3b90caf76a14fcfb022afb096552c21f5898d37cd3972f63539a7ced"
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
