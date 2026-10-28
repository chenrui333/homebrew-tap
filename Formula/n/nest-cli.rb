class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-12.0.11.tgz"
  sha256 "5157ec83e802bbb34db91fbe5806e0302442c525c9304fdb3d9d3764470f833a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9179341400e05a68bdce03ee4cc6dc1e3f3df7966432d6b4d301f49d0c5ddde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9179341400e05a68bdce03ee4cc6dc1e3f3df7966432d6b4d301f49d0c5ddde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a068f853ed1b76e395f493213a4e0caca01f66be90f8b015b990e59f8dcfe906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a068f853ed1b76e395f493213a4e0caca01f66be90f8b015b990e59f8dcfe906"
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
