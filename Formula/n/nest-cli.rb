class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-12.0.9.tgz"
  sha256 "875e1612c8a09b7fc7fdef1cc5326f320c043fd82a1cf2da6a67a114942e15cc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8a4cc3e23bd773bcdd8e3c0f70734d032c93632ed4f2f727878e458ea5d293f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8a4cc3e23bd773bcdd8e3c0f70734d032c93632ed4f2f727878e458ea5d293f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "372f0d8440a7f0be7ef5ad94c6e6a0f437ab7e4cf9a44c89aabdcef33ff2bbf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372f0d8440a7f0be7ef5ad94c6e6a0f437ab7e4cf9a44c89aabdcef33ff2bbf7"
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
