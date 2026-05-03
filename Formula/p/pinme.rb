class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.4.tgz"
  sha256 "f154d6f6cf784e2c4fc4142d488ed1a7f334f611451bee13f60229684783c355"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ab5d443ae7c9ec7c9c6eeda7356f1f6c18089e66f3dfd02185445ba805b4caa5"
    sha256 cellar: :any,                 arm64_sequoia: "cf7ff6791bb009b0c06c03e1343486db1c2220cbc2cd5577c1caf8dfdc1a180b"
    sha256 cellar: :any,                 arm64_sonoma:  "cf7ff6791bb009b0c06c03e1343486db1c2220cbc2cd5577c1caf8dfdc1a180b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0b4a6befa2f80bfbe3eb6e22fe90cbbb553ae0d60570dd9e99795523d85395e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9abc942d675308601deadd019da45d3c3a2ea04bac505fca7ec00bae424e3e05"
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
    assert_match "Request: GET /my_domains", shell_output("#{bin}/pinme domain 2>&1")
    assert_match "No upload history found", shell_output("#{bin}/pinme ls")
  end
end
