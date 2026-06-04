class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-2.0.10.tgz"
  sha256 "2e321c51ea141861bd612195ec2675cd47f2ab9f4d392ddece9087d6979ad6bf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "6da6f2c18b31830c0266769ceb485ed6a54902c787ed1a76d0a43c925c4ce3a9"
    sha256 cellar: :any, arm64_sequoia: "7e805b72be835c708f26d189ab9e9da04eec53253217ed6859294a0d4bc8d856"
    sha256 cellar: :any, arm64_sonoma:  "7e805b72be835c708f26d189ab9e9da04eec53253217ed6859294a0d4bc8d856"
    sha256 cellar: :any, arm64_linux:   "6e997ab5cd17d42e7c184b474a9ef8a0e197b073bdb2cd383accbf3987b2fda9"
    sha256 cellar: :any, x86_64_linux:  "af64d31f05a8f158adc09a1ec2ce92ae913ba67130c607c480ea271f34efaa49"
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
