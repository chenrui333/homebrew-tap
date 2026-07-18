class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.33.0.tgz"
  sha256 "2fd74141cb7e2a3095b535f7ce5b4e6b726325e48c5df25c5cd45e9024ee0041"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de016cc27e220d62b49a52f14b79b4ab067d964ecebe21e113acf6f3ecf2a5b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de016cc27e220d62b49a52f14b79b4ab067d964ecebe21e113acf6f3ecf2a5b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de016cc27e220d62b49a52f14b79b4ab067d964ecebe21e113acf6f3ecf2a5b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9620671b22fd341895287236e4ea0c35bdbc9d0d44df344276c8d4e61b308f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977b3156f9a3817af7ae86efb5619276cdd3c7106b40932de05d1defaf3a4bdb"
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
