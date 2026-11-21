class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-12.0.15.tgz"
  sha256 "6aabe933af7f3a71c8d98c5172b8540d50134a3e60de6ec065faef673d28c07d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "619e7b47d8f005a76fbb374827dec27b1b10c00de3b5e0bb76de07909c312101"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3be7869aea5ab9201fc04bcffdd4e9942c03cf2a6f7e64e68c6eb353684a3abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be7869aea5ab9201fc04bcffdd4e9942c03cf2a6f7e64e68c6eb353684a3abb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51ea1fe9dbb9084c6a002592dfaa63f9002cf5ba424102f9e50411120f6d4da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ea1fe9dbb9084c6a002592dfaa63f9002cf5ba424102f9e50411120f6d4da9"
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
