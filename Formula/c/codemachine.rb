class Codemachine < Formula
  desc "CLI-native orchestration engine for autonomous workflows and production-ready code"
  homepage "https://codemachine.co/"
  url "https://registry.npmjs.org/codemachine/-/codemachine-0.7.0.tgz"
  sha256 "931959597c409a1dbf60a2edd1e8416e3f8ffc2a2aa9d7c8d30db3b313404c8b"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codemachine --version")
  end
end
