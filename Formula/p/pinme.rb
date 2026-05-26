class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.6.tgz"
  sha256 "f44b5b96c15e2a5e7aaf0cac26536d8765b9411cd7bcb1e2afcd39d213b11aa1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a5b00686aebaf9d31f668630f65fa7417222c43fdca36c158b45b5dcf05d7705"
    sha256 cellar: :any,                 arm64_sequoia: "9574be216f212a7eac3bdcabd11c70704cab65ce967d2f10b88fbe49dc5c2625"
    sha256 cellar: :any,                 arm64_sonoma:  "9574be216f212a7eac3bdcabd11c70704cab65ce967d2f10b88fbe49dc5c2625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5202bea639539d6b652c2ca69b58205d31be18aadcbdc7bb9a44d65bd236e916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f55a26803dcdfc624461f27d3619db1508a1a2e390e7a681e83b51a3a13f746"
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
