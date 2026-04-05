class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.1.tgz"
  sha256 "28ec3e233662369043af8b62c3c8dbd2f1479785a5fee249227a3a7c27c50f0b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "70801600b71fc33b074ef72d2398540d8ec9d4a762800e9530be252f32226596"
    sha256 cellar: :any,                 arm64_sequoia: "cf894233ff55f5e5b90ca5be641b1834d5ac3b439b3e5b0cc30ca818d0bbc5f1"
    sha256 cellar: :any,                 arm64_sonoma:  "cf894233ff55f5e5b90ca5be641b1834d5ac3b439b3e5b0cc30ca818d0bbc5f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b6ed5ec6acc6fa7328d2c9e03ec5829aa32298bb1a8e6b8859f8efdbf6d41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce32ab4a73be9897aeaebb9b89741002cea32cadd1133d19378f55fd4680ce63"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/pinme/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries.
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinme --version")
    assert_match "Failed to fetch domains: Auth not set", shell_output("#{bin}/pinme domain")
    assert_match "No upload history found", shell_output("#{bin}/pinme ls")
  end
end
