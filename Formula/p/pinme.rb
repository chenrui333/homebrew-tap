class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.0.tgz"
  sha256 "dd8989d8e81e03155f5a1a5e7f20560ee7c270b5f6173fcc3ec1721fd5823a4d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "061bb5503a07358b71d9221c97248f6e7dbce1db11168fd22caba4f3651504d5"
    sha256 cellar: :any,                 arm64_sequoia: "d41be75ebe1f2f7c71fe261bc2123435f7919cec7cf96acbf801ce5dc2bbeed8"
    sha256 cellar: :any,                 arm64_sonoma:  "d41be75ebe1f2f7c71fe261bc2123435f7919cec7cf96acbf801ce5dc2bbeed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5ddc6bb0404aad381ad22ed8e3dfa9633ad9e1ada5ee7b92e9b3ae66fe7a66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee0b77d583f4b2241fc50518ae14d818f72b4114e35546c6cf53d1921550bc7b"
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
    assert_match "Failed to fetch domains: Auth not set", shell_output("#{bin}/pinme domain")
    assert_match "No upload history found", shell_output("#{bin}/pinme ls")
  end
end
