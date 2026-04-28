class FastCli < Formula
  desc "Test your download and upload speed using fast.com"
  homepage "https://github.com/sindresorhus/fast-cli"
  url "https://registry.npmjs.org/fast-cli/-/fast-cli-4.0.1.tgz"
  sha256 "7deda4c3be0466cff2f190e4510978d0dfc608bec66d494638063cb0d563c092"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "eb10af35af1366c9dc85ceed1724494542f5031a7f574326f190c2a8047c4faa"
    sha256 cellar: :any,                 arm64_sonoma:  "7ee5dd33389d33b49d4bf852d2122af372275826fd95cbd14fbc39205b74954a"
    sha256 cellar: :any,                 ventura:       "e09002411ce9f9f2c7927a92ec30bc6f7f2bccabc572f16c8517e6a62c351358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae49712cf16809c0e628fb8f6f646bda9293bbc98897a71810939c79e2102ba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/fast-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fast --version")
    assert_match "Could not find Chrome", shell_output("#{bin}/fast --upload 2>&1")
  end
end
