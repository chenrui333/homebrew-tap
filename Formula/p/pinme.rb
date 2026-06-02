class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.9.tgz"
  sha256 "dc85e333606de7765fb21bd3ecd817305ec8ee549e28db88eb5e2883b8c86248"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "991165d5b858d6e639553e6ae603472546412a1a60af1d2127eedcdd2a91eeec"
    sha256 cellar: :any,                 arm64_sequoia: "7581691c5e4a63f1ed588764f7223c90bd846a3ac328789ece53ec1275516620"
    sha256 cellar: :any,                 arm64_sonoma:  "7581691c5e4a63f1ed588764f7223c90bd846a3ac328789ece53ec1275516620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b8cb1aa9fe718fd9c30d91e4b3b8c73b70eef9cacf0398e92dcd9be99c60dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4c3e2e4579352765dd01fcaa6ef2ac7f40a6cdbbfd3bc1ce0d9d67e41de6e3"
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
