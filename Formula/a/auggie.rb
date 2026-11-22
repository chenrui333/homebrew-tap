class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-1.2.1.tgz"
  sha256 "2050e3f4ad982f60cbf994919cf1b097bc6c4dcf8fbb0cd4e371f60668018f2d"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "7943a9f822d1814a17b8de4a21ca25fbe0b4ec93cf9ee76e5413e7545891e502"
    sha256 cellar: :any,                 arm64_tahoe:   "ca16b175bf1545b3291c08075fe156f9815695928584fe1308db8a9160039cf5"
    sha256 cellar: :any,                 arm64_sequoia: "ca16b175bf1545b3291c08075fe156f9815695928584fe1308db8a9160039cf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d6e9b772d018304c3450ac52d19727b044df1b72e6797523b2638d4d296a168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74aa1947bfb49fbe7fc9a357573328b3cebeefd730edd977249d2aa2f899b19b"
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
