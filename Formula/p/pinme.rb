class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.12.tgz"
  sha256 "1e5a42cb86a6011994953d963dac3b142ab895d7b663f00de1fc93086742c1ef"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "1c695eab7003134bc24a5076c7fb69d4ac5d4c326e7f483f6548275a304aac5c"
    sha256 cellar: :any, arm64_sequoia: "e6167906649e6f0ebcafe78748fb95586b24c2259b43e677f92076d6a9162eb2"
    sha256 cellar: :any, arm64_sonoma:  "e6167906649e6f0ebcafe78748fb95586b24c2259b43e677f92076d6a9162eb2"
    sha256 cellar: :any, arm64_linux:   "f4eaaf5bd18e08341e6489f350a795a1ac50c231731b24ff94ee4aa28f3b6dab"
    sha256 cellar: :any, x86_64_linux:  "b1e0e94aeca1325a10e0f890cfe75587a5dfb138ed334a33c0a624511843b87d"
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
