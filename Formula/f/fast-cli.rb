class FastCli < Formula
  desc "Test your download and upload speed using fast.com"
  homepage "https://github.com/sindresorhus/fast-cli"
  url "https://registry.npmjs.org/fast-cli/-/fast-cli-5.2.0.tgz"
  sha256 "05e8cd8259e60631c280efb8e0d8c985aef402c76e8953f234bc4c3028b8fed5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "294aea85285c637ed567691d94333b3be008bda36e345ceccca9c2230c07ab1a"
    sha256 cellar: :any,                 arm64_sequoia: "5301a9de2ab924542e18e3c021a7e6147174387c42658e120d5af002a5ea30a1"
    sha256 cellar: :any,                 arm64_sonoma:  "5301a9de2ab924542e18e3c021a7e6147174387c42658e120d5af002a5ea30a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abec3273668dbb98524305df63753376b766e6b3ba8128dce9d6cbb87836e701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30edafc62521d5df79b230cba8b1105769901971d7f49696be43e228b45c0a3a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/fast-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fast --version")
    assert_match "Could not find Chrome", shell_output("#{bin}/fast --upload 2>&1", 1)
  end
end
