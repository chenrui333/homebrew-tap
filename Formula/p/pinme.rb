class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.12.tgz"
  sha256 "1e5a42cb86a6011994953d963dac3b142ab895d7b663f00de1fc93086742c1ef"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "543c88ff405ea3a036e0edf9fadb083f5c682d73b1e687395c09d670720dea92"
    sha256 cellar: :any, arm64_sequoia: "543c88ff405ea3a036e0edf9fadb083f5c682d73b1e687395c09d670720dea92"
    sha256 cellar: :any, arm64_linux:   "26a6d5d7b4bbcae186b6f31ee360e58c1ed4ce42f7a2db87b0790b87b92aeca3"
    sha256 cellar: :any, x86_64_linux:  "e59617b541d62d0d482d8fd1d2dbb60ae015346d66b7960ea1ffeafd59a6030f"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

    node_modules = libexec/"lib/node_modules/pinme/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries.
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinme --version")
    assert_match "No AppKey found", shell_output("#{bin}/pinme show-appkey")
    assert_match "Invalid token format", shell_output("#{bin}/pinme set-appkey invalidkey 2>&1")
    assert_match "No upload history found", shell_output("#{bin}/pinme ls")
  end
end
