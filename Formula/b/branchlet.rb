class Branchlet < Formula
  desc "Simple CLI Git worktree manager"
  homepage "https://github.com/raghavpillai/branchlet"
  url "https://registry.npmjs.org/branchlet/-/branchlet-1.2.0.tgz"
  sha256 "8f536156dd532edd5b461359dc929892d85e3352b58134c49d571b6f9614261b"
  license "MIT"

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
