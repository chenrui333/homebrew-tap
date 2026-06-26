class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.5.tgz"
  sha256 "ce39b1312c199214728d4bb9f065d3c8abe499156f572b43dd84dd6a299df383"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "024c15ad3a27320894fc0ef75d4ca02f4b86054147606a67f52b03e4d4e0b697"
    sha256                               arm64_sequoia: "024c15ad3a27320894fc0ef75d4ca02f4b86054147606a67f52b03e4d4e0b697"
    sha256                               arm64_sonoma:  "024c15ad3a27320894fc0ef75d4ca02f4b86054147606a67f52b03e4d4e0b697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654b0c65e88734a9391ca0498eda06d9e779c7f76413f4be946e8f4c48e0b500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "230dff60f558aa19fc59ea954b6081e11093f07c82bee89acfe968f255f9face"
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
