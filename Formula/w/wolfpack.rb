class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.22.tgz"
  sha256 "91a328b6c2f6869e8a33a1b3d2b2cae5ec21567764a61333e0ecb577703e2a1b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "bde9456b3e3092cd8bd5e2b7ccbb95bd29e7f51cd8cb843cc52581c32fdc967b"
    sha256                               arm64_sequoia: "bde9456b3e3092cd8bd5e2b7ccbb95bd29e7f51cd8cb843cc52581c32fdc967b"
    sha256                               arm64_sonoma:  "bde9456b3e3092cd8bd5e2b7ccbb95bd29e7f51cd8cb843cc52581c32fdc967b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94ae3380feae599e2849f74603cda076c8b4a79cad48a65e1c48baa62e03c0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c106ad6006810d6d0707524b2e2be5236f9115bed7101bb3c5e5e40832de45"
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
