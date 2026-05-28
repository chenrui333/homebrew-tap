class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.7.tgz"
  sha256 "3040a1fc4d882089e253ab3d73762fa4c7adc07fad43f56ba82384da141adf30"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "051df3756382f7c8a01e4c605f7aab09f49680d37c316ce466c666295124100b"
    sha256 cellar: :any,                 arm64_sequoia: "416dfc11cf098f204f305f7e7ee73f1457603b291a14a91fef9315db79f37943"
    sha256 cellar: :any,                 arm64_sonoma:  "416dfc11cf098f204f305f7e7ee73f1457603b291a14a91fef9315db79f37943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cdf511f7ce92a0e1332d5f18fde94f19b525d05506a64efa9776940c3dfd180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78bb18640cfb4a253a09d106fccce26f3821b039349dedf49994e91f4b31e752"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/pinme/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries.
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinme --version")
    assert_match "Request: GET /my_domains", shell_output("#{bin}/pinme domain 2>&1")
    assert_match "No upload history found", shell_output("#{bin}/pinme ls")
  end
end
