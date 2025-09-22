class Ccapi < Formula
  desc "Claude Code Commands Manager"
  homepage "https://github.com/4xian/claude-auto-api"
  url "https://registry.npmjs.org/@4xian/ccapi/-/ccapi-1.0.8.tgz"
  sha256 "4845ecaa62b7df2f336a6153159b04cbe4df73716d8418bdf23aeb2961795fff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e6a9bd9932de47bc5d00ffa3f9aefd3d4a2239694e4c4fdcb0bf1992ffbcb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34ae584e4d769139b468416f1ec32a250ca9030f368b582e8bc4b5735a5ed75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d1680dc50bb6e1e6a556b5e774e88f4d94f618d78980ff6735d6a64ec5cea2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccapi --version")

    output = shell_output("#{bin}/ccapi list 2>&1", 1)
    assert_match "列举配置失败: settings.json file path not set", output
  end
end
