class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.5.3.tgz"
  sha256 "ce35fd5af9eca4c390f88cc4540c70980fe559e6afbe4673c5b583a32f6fa24e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c823f9f867f9fac43068728a3b299f39297d0c21d5ea4c5690bf7f40013daa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20a2d7face3a525173556af091f7ae224e295b3593c207b6231594b4ba71c8d"
    sha256 cellar: :any_skip_relocation, ventura:       "2a7bd58072a0103b0cc0d689cba6a201f4113e80a308ac50be25818b66e465f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54c8627cfdc6453bd6a26f1e5b08864098cf7960137fe8435b59b70e9a609878"
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
