class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.4.tgz"
  sha256 "f154d6f6cf784e2c4fc4142d488ed1a7f334f611451bee13f60229684783c355"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b203d24de6527271834805e29d5d4998911f5be974dc2524b3bc7fafc8d0c40f"
    sha256 cellar: :any,                 arm64_sequoia: "42db69377a42901b33ab48392a852722eeaf88a82ce08ba8dfa9d030f12e23ce"
    sha256 cellar: :any,                 arm64_sonoma:  "42db69377a42901b33ab48392a852722eeaf88a82ce08ba8dfa9d030f12e23ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4326ecc835bc13dcd139afe47b3310dfb583fefbc6bd722fcc27f2c2031c5be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5df73325319433ba7125286f36245619799e2a3051d7aa2dfd7bac472c77f79a"
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
