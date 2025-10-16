class Ccapi < Formula
  desc "Claude Code Commands Manager"
  homepage "https://github.com/4xian/claude-auto-api"
  url "https://registry.npmjs.org/@4xian/ccapi/-/ccapi-1.0.9.tgz"
  sha256 "8485beae17fcc462cee4c064a13caf349f86ffc9652c6d467494bb2f5ac4195b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da49111a510259723741399a74b56a8d8169dd3cc4acdbb14d12ae0642237cd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d7cd2149d73a2160570ced02193825a1744a9f0edd995aac45f7f8e6b5cf277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a29898a36d929664b8894a716861b2620287e5e3e15be9a5d119c4155aeda552"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccapi --version")

    output = shell_output("#{bin}/ccapi list 2>&1", 1)
    assert_match "列举Claude配置失败: settings.json file path not set", output
  end
end
