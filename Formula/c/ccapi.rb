class Ccapi < Formula
  desc "Claude Code Commands Manager"
  homepage "https://github.com/4xian/claude-auto-api"
  url "https://registry.npmjs.org/@4xian/ccapi/-/ccapi-1.0.5.tgz"
  sha256 "d967e3f737de30ebc1667bf6d1d0a4c35127ca285b11bdbb576995df8188eff0"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccapi --version")

    output = shell_output("#{bin}/ccapi list 2>&1", 1)
    assert_match "未设置settings.json路径", output
  end
end
