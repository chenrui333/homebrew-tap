class FastCli < Formula
  desc "Test your download and upload speed using fast.com"
  homepage "https://github.com/sindresorhus/fast-cli"
  url "https://registry.npmjs.org/fast-cli/-/fast-cli-5.2.0.tgz"
  sha256 "05e8cd8259e60631c280efb8e0d8c985aef402c76e8953f234bc4c3028b8fed5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6e8d0e9548345909eed7eaefe74337dc62f2b6f97b26ee5c330a13c13b6ceae3"
    sha256 cellar: :any,                 arm64_sequoia: "5595a5ea313b7f13f21e36e542bc9dadf6cc1bffe97a654b067f1856a9559087"
    sha256 cellar: :any,                 arm64_sonoma:  "5595a5ea313b7f13f21e36e542bc9dadf6cc1bffe97a654b067f1856a9559087"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9fa7bd62c3039ebd7c7d4889a7701c136b5815baadd839aff5bb83d248a9682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7977024fac64646d3555fd118176f629796a21e5b4841f71fbd5dedd983e6f"
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
