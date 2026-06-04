class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.10.tgz"
  sha256 "2e321c51ea141861bd612195ec2675cd47f2ab9f4d392ddece9087d6979ad6bf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "87eebe2207f7dabb4ba485e2383093e9ee9f99f76268471122f5ade99d4ed79d"
    sha256 cellar: :any, arm64_sequoia: "db6397863a50891e2b7bec1a1e2cd0f0515702f05ddf953286283ec21fae6297"
    sha256 cellar: :any, arm64_sonoma:  "db6397863a50891e2b7bec1a1e2cd0f0515702f05ddf953286283ec21fae6297"
    sha256 cellar: :any, arm64_linux:   "a3d041219d44ae0770dd9ed44d50ac2a722410c9cbca17317314d584b56685e7"
    sha256 cellar: :any, x86_64_linux:  "a67700738f387a475ab5a51f350dbca00186232705b4db17adc39ba782c80496"
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
