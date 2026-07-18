class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.33.0.tgz"
  sha256 "2fd74141cb7e2a3095b535f7ce5b4e6b726325e48c5df25c5cd45e9024ee0041"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d07913f17e02ec0dccb06eebb0449fea56bc4f69236da72248f494bf2a3cac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d07913f17e02ec0dccb06eebb0449fea56bc4f69236da72248f494bf2a3cac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d07913f17e02ec0dccb06eebb0449fea56bc4f69236da72248f494bf2a3cac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b108af8f5c9710a13e3885f00390dd77855b192419892493fb2e831afaff9511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a828fee5462571ac6ff1bd8442d0c24f713f53edebec41cab67591f6247e82f6"
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
