class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.36.0.tgz"
  sha256 "4fef6ddbd9083f14e403c1ef9326c8f5a800a383731416b6c438a04d17e8f5ab"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b6d9b278e0e3192cd3d4af91766f97387384c5b31b454e5dd4a596cefa31a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b6d9b278e0e3192cd3d4af91766f97387384c5b31b454e5dd4a596cefa31a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b6d9b278e0e3192cd3d4af91766f97387384c5b31b454e5dd4a596cefa31a3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "284cef56aeed32c96e8e7de25c571b9b209b0a78e14dfba893656403f3b7a761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a501cbdc74cd6719f9af26ed7c2dbf2fb5c209be6a1427ca8d306af43dba54ae"
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
