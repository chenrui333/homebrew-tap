class Preevy < Formula
  desc "Quickly deploy preview environments to the cloud"
  homepage "https://preevy.dev/"
  url "https://registry.npmjs.org/preevy/-/preevy-0.0.64.tgz"
  sha256 "24956a8a0248bcbde2cb8462a7deab3e6b9f8465fe17566703ca5d7cd78c841a"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/preevy --version")

    output = shell_output("#{bin}/preevy ls 2>&1", 2)
    assert_match "Error: Profile not initialized", output
  end
end
