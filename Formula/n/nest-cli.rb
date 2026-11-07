class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-12.0.12.tgz"
  sha256 "07dd991c5b26f2995ef26e2c5fab06dd71f41820ab47a0081b51ed80ca5c7675"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f63047f7f1896066a6b1f8115988c6b5826096d416c5f46094b5aeb0e220e9c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f63047f7f1896066a6b1f8115988c6b5826096d416c5f46094b5aeb0e220e9c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8108f5356725efe690d26a9fadf439b49cc6a4e7d8a2b919f367a58043a06a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8108f5356725efe690d26a9fadf439b49cc6a4e7d8a2b919f367a58043a06a3c"
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
