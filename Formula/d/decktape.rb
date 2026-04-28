class Decktape < Formula
  desc "PDF exporter for HTML presentations"
  homepage "https://github.com/astefanutti/decktape"
  url "https://registry.npmjs.org/decktape/-/decktape-3.15.0.tgz"
  sha256 "9ef30a860f2b9a89a3f7143cf4961a8887302d8a53b44cc69958254e44b5eb33"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "096547e8ff0f64153853de94592430ef254574d19f4aef291ae9d95b34801465"
    sha256 cellar: :any,                 arm64_sonoma:  "0b03711a2ba31a78b8408a17d771864fd4bd33a56bd25602b69b0582b50680fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fb604c65c9885442e64e5832403851efdd37d1c9de2ac388c6ed0072e09075b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/decktape/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decktape version")
  end
end
