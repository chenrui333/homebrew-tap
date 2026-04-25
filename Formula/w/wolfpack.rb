class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.1.tgz"
  sha256 "2aaac8765a6a4b366533bccff03d3b6135acff8fa40a655ec3f7a99005a14899"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a0d4d5a47986c63d2599a3b5f03cdcb8e3a17da2ec1ff97627cb1358bfafbba3"
    sha256                               arm64_sequoia: "a0d4d5a47986c63d2599a3b5f03cdcb8e3a17da2ec1ff97627cb1358bfafbba3"
    sha256                               arm64_sonoma:  "a0d4d5a47986c63d2599a3b5f03cdcb8e3a17da2ec1ff97627cb1358bfafbba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ad84f847230557265f8ae914a75255e038447f52bf7a59a6b181fa214e85e97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828e081df7c5181609c403cf069ff951a91712cc44b3b6012d89200bda3e7e1d"
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
