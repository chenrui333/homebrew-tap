class Shortest < Formula
  desc "AI-powered natural language end-to-end testing framework"
  homepage "https://github.com/antiwork/shortest"
  url "https://registry.npmjs.org/@antiwork/shortest/-/shortest-0.4.9.tgz"
  sha256 "0e239bceeda97a65178b7e4b6be16cc88c67e047eeb71bfd2da04441156180f8"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["GITHUB_TOTP_SECRET"] = "test"

    assert_match version.to_s, shell_output("#{bin}/shortest --version")

    output = shell_output("#{bin}/shortest github-code")
    assert_match "GitHub 2FA Code", output
  end
end
