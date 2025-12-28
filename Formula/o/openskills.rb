class Openskills < Formula
  desc "Universal skills loader for AI coding agents"
  homepage "https://github.com/numman-ali/openskills"
  url "https://registry.npmjs.org/openskills/-/openskills-1.3.0.tgz"
  sha256 "88ab379000b618e3a460305e306cd2260eca4618ac65c50345e56ae77059f917"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "16d9ec949356c039e07ccd241dc13bb60e938887ea2386b741642886603cdd78"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # version report has issue, https://github.com/numman-ali/openskills/pull/27
    # assert_match version.to_s, shell_output("#{bin}/openskills --version")
    system bin/"openskills", "--version"
    assert_match "No skills installed", shell_output("#{bin}/openskills list")
  end
end
