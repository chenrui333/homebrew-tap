class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-1.2.2.tgz"
  sha256 "3558daa13f73611237ac9ee611bcc0b3751f4e0f2dfbcfd36028f0ccca34b5fc"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "fed5182b98ac659777a4ab578509856fcf424046ef1e1a8ccb776007fed73dbe"
    sha256 cellar: :any,                 arm64_tahoe:   "92811378f530a0900c668aaf0908229572def36d1796f2aab5cfe9d994b82ee5"
    sha256 cellar: :any,                 arm64_sequoia: "92811378f530a0900c668aaf0908229572def36d1796f2aab5cfe9d994b82ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe40b94323d55b4dfd9bd8b5e09bd5fff334c643aa6b926007ca12fb6b5af16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a3e120a6b812b6fd0c645b97fe8ebc47f6f77109c8531f4cb32e553f165407"
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
