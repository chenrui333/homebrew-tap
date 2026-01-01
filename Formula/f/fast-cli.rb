class FastCli < Formula
  desc "Test your download and upload speed using fast.com"
  homepage "https://github.com/sindresorhus/fast-cli"
  url "https://registry.npmjs.org/fast-cli/-/fast-cli-5.1.0.tgz"
  sha256 "5bb4b946dd387089be225a31156a2a8cea968b6a91d14cf59f0e63057705d95a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "4de9e2c3557e059c4ab5a66b44dff2ba1cbac93285a14a94c8f1f79c68a8e140"
    sha256 cellar: :any,                 arm64_sonoma:  "b67a1c6c6de7cec641805b157e401c2101d7e3946c7d89516d7ac33ef94021d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1284306ee16467233b40887b5ecbbfc50e7cbfa5dbb980c4eb4970e068f4fceb"
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
