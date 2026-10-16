class FastCli < Formula
  desc "Test your download and upload speed using fast.com"
  homepage "https://github.com/sindresorhus/fast-cli"
  url "https://registry.npmjs.org/fast-cli/-/fast-cli-6.0.0.tgz"
  sha256 "7b0026d3bfdea5e236abb2ee5bbef8702d1daf02554262cb2fc343e4a6e19e7c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "79d9245d291d7a9c55982bf4435ab0c20a5552c5d2cb086b7d3c5feeb188d8c8"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/fast-cli/node_modules"

    # Remove incompatible pre-built Bare module binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fast --version")

    (testpath/"offline.cjs").write <<~JS
      const dns = require("node:dns/promises");
      dns.lookup = async () => { throw Object.assign(new Error("offline"), {code: "ENOTFOUND"}); };
    JS
    ENV["NODE_OPTIONS"] = "--require=#{testpath}/offline.cjs"
    assert_match "Please check your internet connection", shell_output("#{bin}/fast --upload 2>&1", 1)
  end
end
