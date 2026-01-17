class Openskills < Formula
  desc "Universal skills loader for AI coding agents"
  homepage "https://github.com/numman-ali/openskills"
  url "https://registry.npmjs.org/openskills/-/openskills-1.3.1.tgz"
  sha256 "93d30fa7a8757eb51d6be27399aa9e8516cc44803aee5afee609a10274d97252"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "e1cef110c811ac46b8994535ac6f4146b77d249c06a38af01d2962a0fb2a40fd"
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
