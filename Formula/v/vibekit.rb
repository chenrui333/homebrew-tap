class Vibekit < Formula
  desc "Safety layer for your coding agent"
  homepage "https://www.vibekit.sh/"
  url "https://registry.npmjs.org/vibekit/-/vibekit-0.0.2-rc.9.tgz"
  sha256 "d92a5255939e14488ddb5e2822d5da1c08af5b152414e5ad3b56adf2862c15b4"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibekit --version")
    assert_match "Status: DISABLED", shell_output("#{bin}/vibekit sandbox status")
    assert_match "No analytics data found", shell_output("#{bin}/vibekit analytics --summary")
  end
end
