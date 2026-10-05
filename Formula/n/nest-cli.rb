class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-12.0.8.tgz"
  sha256 "beff4d8e4fd8cba594e8443f46160a170b31eab6018f700b20dd99b4133473df"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb7707e8af709b6824e10452bddf651a984cd16a249318e42081416225ef12ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb7707e8af709b6824e10452bddf651a984cd16a249318e42081416225ef12ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5de51405d3f17d87651a853cf4bf1727756be86f81c0d31cffede892b1908708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5de51405d3f17d87651a853cf4bf1727756be86f81c0d31cffede892b1908708"
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

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@nestjs/cli/nest-app/node_modules/{@napi-rs,@swc}/*")
           .each { |dir| rm_r(dir) unless dir.basename.to_s.include?("#{os}-#{arch}") }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nest --version")

    output = shell_output("#{bin}/nest info")
    assert_match "System Information", output
  end
end
