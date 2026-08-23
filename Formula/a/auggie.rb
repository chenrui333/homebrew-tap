class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.36.0.tgz"
  sha256 "4fef6ddbd9083f14e403c1ef9326c8f5a800a383731416b6c438a04d17e8f5ab"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dff7c81cbf2f2e3c7ebb4a5863dce2f07247bbfea50211460f1fe4785472a28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dff7c81cbf2f2e3c7ebb4a5863dce2f07247bbfea50211460f1fe4785472a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dff7c81cbf2f2e3c7ebb4a5863dce2f07247bbfea50211460f1fe4785472a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc5cfa516ad8717eb2af4c88b4027084821380bcf318fd136ee570d5c972ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bdfb6c991b29d18536c6309ffa6ab0075b9d2e02ba655b1f7bd6ed996f5fd85"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}"
    prebuild_dir = libexec/"lib/node_modules/@augmentcode/auggie/node_modules/node-pty/prebuilds"
    prebuild_dir.each_child { |dir| rm_r(dir) if dir.basename.to_s != native }

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auggie --version")

    tools_output = shell_output("#{bin}/auggie tools list")
    assert_match "Total:", tools_output

    model_output = shell_output("#{bin}/auggie model list 2>&1", 1)
    assert_match "not currently logged in", model_output
  end
end
