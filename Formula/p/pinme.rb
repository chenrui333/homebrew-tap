class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.6.tgz"
  sha256 "f44b5b96c15e2a5e7aaf0cac26536d8765b9411cd7bcb1e2afcd39d213b11aa1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cd58b18b6f030ba4ac2d0654f3028e0d416aa38918047182086483d2f461d3ac"
    sha256 cellar: :any,                 arm64_sequoia: "f9c88e6755f7cb5d3f5e0c9a63572357fb932df8dba6440bd08ce440303447d2"
    sha256 cellar: :any,                 arm64_sonoma:  "f9c88e6755f7cb5d3f5e0c9a63572357fb932df8dba6440bd08ce440303447d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "486e5d33f92eea4fc90eb157f8519d2a3876ea6aeb2f3c979786090c84e621dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7c8e447313f10b600be622193c7a476e03457d809ecc08faaaa4e634a9c7ed5"
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
