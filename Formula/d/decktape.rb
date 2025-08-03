class Decktape < Formula
  desc "PDF exporter for HTML presentations"
  homepage "https://github.com/astefanutti/decktape"
  url "https://registry.npmjs.org/decktape/-/decktape-3.15.0.tgz"
  sha256 "9ef30a860f2b9a89a3f7143cf4961a8887302d8a53b44cc69958254e44b5eb33"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "f4d1d01055da09f051c28dbbfe7730146278e150a8756c090f0552bdd027b7de"
    sha256 cellar: :any,                 arm64_sonoma:  "8e4a84624f60136a0df2eb4ffc343bdb8cf0c63d9506e25c0d11eb10e14e1bc0"
    sha256 cellar: :any,                 ventura:       "1b983b544ff7521567edaf475982a556166ee50b605221a2c5e11f7f4df05949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b8ab8c438064289bf0cc37827763b0ca3023a79b19306947f2d8f100a89cbb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/decktape/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decktape version")
  end
end
