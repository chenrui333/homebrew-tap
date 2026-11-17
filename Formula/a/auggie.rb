class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-1.2.1.tgz"
  sha256 "2050e3f4ad982f60cbf994919cf1b097bc6c4dcf8fbb0cd4e371f60668018f2d"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60ad694b0046f42e7fd28f281575afa1b6253985c5694f14586e611574485505"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60ad694b0046f42e7fd28f281575afa1b6253985c5694f14586e611574485505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81830f5713959691e5fd1c7b6561dd79c9bd5fa1ae9d106901eda6e988020a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "325b76e753b289cf7286112d2aa00167d30939a36d775cc4f8ec048aa25e65b3"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "install", "--offline", *std_npm_args

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@augmentcode/auggie/node_modules"
    (node_modules/"node-pty/prebuilds").each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    (node_modules/"koffi/build/koffi").each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}" }

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["PI_OFFLINE"] = "1"

    assert_match version.to_s, shell_output("#{bin}/auggie --version")

    models = JSON.parse(shell_output("#{bin}/auggie model list --json"))
    assert_empty models.fetch("models")

    output = shell_output("#{bin}/auggie auth status 2>&1", 1)
    assert_match "Not logged in.", output
  end
end
