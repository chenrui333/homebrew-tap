class Branchlet < Formula
  desc "Simple CLI Git worktree manager"
  homepage "https://github.com/raghavpillai/branchlet"
  url "https://registry.npmjs.org/branchlet/-/branchlet-1.2.0.tgz"
  sha256 "8f536156dd532edd5b461359dc929892d85e3352b58134c49d571b6f9614261b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "df5714374af7a505b1e079bbbee448071f418b9825c4ec35725a0a94ab35fee1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/branchlet --version")

    output, = Open3.capture2e(bin/"branchlet", "list")
    assert_match "Raw mode is not supported", output
  end
end
