class Decktape < Formula
  desc "PDF exporter for HTML presentations"
  homepage "https://github.com/astefanutti/decktape"
  url "https://registry.npmjs.org/decktape/-/decktape-3.16.1.tgz"
  sha256 "20e4fe92c367f668d87f7a6db41d8ae306e5dde4cdba4bee61453adb98de43fa"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "e0cc62e561b6380befe42b85fbfd24781ed8ffc203c6e835a662c28b025f0c85"
    sha256 cellar: :any, arm64_sequoia: "00d2fe01739e7c01dfda7c2e624afa588141cc9fd24f54dab256e04a5de5d863"
    sha256 cellar: :any, arm64_linux:   "2f6369b4ce040ab93b17c1cbef95b203e15f49c3b85c7ca9a3df913949eb0933"
    sha256 cellar: :any, x86_64_linux:  "9f45a4261c2a30686dace519813990d1340cd230af8ea3f48919bb39e9cdf1ea"
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

    node_modules = libexec/"lib/node_modules/decktape/node_modules"

    # Remove incompatible pre-built Bare module binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decktape version")

    output = shell_output("#{bin}/decktape --size bad file:///nonexistent #{testpath}/slides.pdf 2>&1", 1)
    assert_match "<size> must follow the <width>x<height> notation", output
  end
end
