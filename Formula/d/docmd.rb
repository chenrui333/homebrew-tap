class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.2.1.tgz"
  sha256 "91ad1ed870147ee2fa14079c9bc724f3008ea4c452acf720715e4f4ce0f10be8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18193e7669d7225f15dd3ace5541e8904b7362f0064ab3b4834608e9a8c91409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f94a5d5745e91da8fdce7b719b0d452e3dd2a058d5eae3b702244d14fab42dac"
    sha256 cellar: :any_skip_relocation, ventura:       "c42db72bfe0d4ddf00bd9c5b0f92a89fe12a97f671c85120cf67c91a0a427d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d2a2f7f192c9f892e0beae43f7fa6be65815194b58517b7735f5ff3d08ed646"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"config.js"
    assert_match "title: \"Welcome\"", (testpath/"docs/index.md").read
  end
end
