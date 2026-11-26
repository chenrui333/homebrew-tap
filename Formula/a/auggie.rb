class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-1.2.3.tgz"
  sha256 "72e95a56cd187e943ebc9818c6d3f374aa3e5705502d5aefaaccb5d609e1efe7"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "086fac22a72ca9bf2c1e52d847d47ab5a279c3c0a30d7514ab6f7194e431b739"
    sha256 cellar: :any,                 arm64_tahoe:   "42b4df37ba4d1c7a99e1c76e7c204f17017b38b1f4c83c72720a51d6114304cd"
    sha256 cellar: :any,                 arm64_sequoia: "42b4df37ba4d1c7a99e1c76e7c204f17017b38b1f4c83c72720a51d6114304cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "379e5f7830628c00eabdcb49beffa92d99c21371bf66c61f4cf8436ec3d6dbbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60ad453bc0538ea91c91d2e1ee333e69cdee22dcdff3e36690b88b73d311f796"
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
