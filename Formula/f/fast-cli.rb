class FastCli < Formula
  desc "Test your download and upload speed using fast.com"
  homepage "https://github.com/sindresorhus/fast-cli"
  url "https://registry.npmjs.org/fast-cli/-/fast-cli-5.2.0.tgz"
  sha256 "05e8cd8259e60631c280efb8e0d8c985aef402c76e8953f234bc4c3028b8fed5"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "eb56d8d50122b98839e514932574192e56af1a5a593e83368094a9ac45a1249d"
    sha256 cellar: :any, arm64_sequoia: "eb56d8d50122b98839e514932574192e56af1a5a593e83368094a9ac45a1249d"
    sha256 cellar: :any, arm64_linux:   "42fdbe2aad145ac8dfd47afd4bfca8da12fe3af4a693bd702491178cd6df6bab"
    sha256 cellar: :any, x86_64_linux:  "35054cbbeb9be7ce1fd6355270ef5d29d11edbfcb5fc11981f82381a99d6c3b1"
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
