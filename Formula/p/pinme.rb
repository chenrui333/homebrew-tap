class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.11.tgz"
  sha256 "18213b232abcc27f4c86ae20b1546a3ca9a1d3e8b7380e603425201ed910d379"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "ce5cc9c990995ebd43eee03723b547b0c7c31de945a9f4d619b195ea0d8f5c95"
    sha256 cellar: :any, arm64_sequoia: "5749d6a1e7b565d0f7b4f949736723549bd937b685d2746884105263553be270"
    sha256 cellar: :any, arm64_sonoma:  "5749d6a1e7b565d0f7b4f949736723549bd937b685d2746884105263553be270"
    sha256 cellar: :any, arm64_linux:   "296c73aaf0a28d9945a6ab89b0b14546540646882ce713456764b3e39d6f1d73"
    sha256 cellar: :any, x86_64_linux:  "7a8058a1369f4ba03d15581c4e09dc1de0ae75d57f78c908e610a92f8c33615a"
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
