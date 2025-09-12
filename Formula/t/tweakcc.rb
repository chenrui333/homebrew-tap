class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.5.3.tgz"
  sha256 "ce35fd5af9eca4c390f88cc4540c70980fe559e6afbe4673c5b583a32f6fa24e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d80d98fcd5033bc75838ebfb96adc9e669cd4619b6802304c24da1c0e6350cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b22593c4ec84a0863243af4cf29aad3740c0d6e57dd46a0d525100ca5bb5c40"
    sha256 cellar: :any_skip_relocation, ventura:       "fb01497de3a932ff981180a889b986bf7049ad63b9b3b89b8d43f09ff7d4433c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d18f943835e3c3713f9bc325d99fc57598520bc3834ad92a94cb32f7e1688f60"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
