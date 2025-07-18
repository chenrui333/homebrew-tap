class FastCli < Formula
  desc "Test your download and upload speed using fast.com"
  homepage "https://github.com/sindresorhus/fast-cli"
  url "https://registry.npmjs.org/fast-cli/-/fast-cli-4.0.1.tgz"
  sha256 "7deda4c3be0466cff2f190e4510978d0dfc608bec66d494638063cb0d563c092"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "64a67e891cfbebcaa6c072b53880770d007db61f88407ad8a4e3ce78e7ef75ff"
    sha256 cellar: :any,                 arm64_sonoma:  "3a9885827a099ad81f6e7a62e2b60df3167de7f0d26712451c0ae63e54f11557"
    sha256 cellar: :any,                 ventura:       "95b140f462754415bfce601ae7e79264192cac8fcf24ffe0d521081d72974d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "709d7197a2b1ac457d4059bc29161e6467494171496a63efb40b748ebf8fa2fc"
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
