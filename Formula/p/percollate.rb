class Percollate < Formula
  desc "CLI to turn web pages into readable PDF, EPUB, HTML, or Markdown docs"
  homepage "https://github.com/danburzo/percollate"
  url "https://registry.npmjs.org/percollate/-/percollate-4.3.0.tgz"
  sha256 "5d3c9949da181b9d9f2011595434801e730637c6e728920191bdc5c458d87a92"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "47b565077b9dbc1ce01e8aceea1fcf141eded409738566c4f90806e35ad650cc"
    sha256 cellar: :any, arm64_sequoia: "47b565077b9dbc1ce01e8aceea1fcf141eded409738566c4f90806e35ad650cc"
    sha256 cellar: :any, arm64_linux:   "4ea6e1832503b813c235d6f31812d3d27c0c9a4c51c21dd9cd41a8b81f3b33f6"
    sha256 cellar: :any, x86_64_linux:  "a951efe381d551f65de20800f427940d91f675878c77b8a2915629470dd33839"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built Bare module binaries
    node_modules = libexec/"lib/node_modules/percollate/node_modules"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/percollate --version")

    # Since percollate requires Chromium, just do a error check in here
    output = shell_output("#{bin}/percollate pdf https://example.com -o my.pdf 2>&1", 1)
    assert_match "Could not find Chromium", output
  end
end
