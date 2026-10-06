class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://secco.lekoarts.de/"
  url "https://registry.npmjs.org/secco/-/secco-3.1.2.tgz"
  sha256 "54c7b9e12cff9abc0f33405780c5f54d49e20b940456e01430ba2f336615c2bc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f223ba91ca5b1d7b11a6a6a475c955c1761f7b227aeaaed83f5a1a3f43370514"
    sha256 cellar: :any, arm64_sequoia: "f223ba91ca5b1d7b11a6a6a475c955c1761f7b227aeaaed83f5a1a3f43370514"
    sha256 cellar: :any, arm64_linux:   "59e1662973274dec5b4c7056ac7419e6531358953bcae59fb178307b783e7703"
    sha256 cellar: :any, x86_64_linux:  "03f210e8bfd6a575830fe1b76e5c5699896e0c4c6f75941711cdf8c671c780a6"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/secco"

    node_modules = libexec/"lib/node_modules/secco/node_modules"

    # Remove incompatible pre-built Bare module binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secco --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0",
        "description": "A test package",
        "main": "index.js",
        "packageManager": "node",
        "scripts": {
          "test": "echo \\"Error: no test specified\\" && exit 1"
        },
        "author": "",
        "license": "ISC"
      }
    JSON

    (testpath/".seccorc").write "source.path=\"#{testpath}\""

    output = shell_output("#{bin}/secco test 2>&1", 1)
    assert_match "You haven't got any source dependencies in your current `package.json`", output
  end
end
