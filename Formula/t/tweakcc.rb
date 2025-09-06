class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.4.0.tgz"
  sha256 "d1074b846adb72c4e82e75b0b4bb06939dc1d19af770d42b1957788b0e2accd1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0eb3a26e5787cdb9e5acb4006bfadadc7d248fedfe317293d01db8eda444706"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f17c65ce2c9acef1a5e4f437d4ac39fb03dcb11e9bbb37d2d14dab68e9b83b5"
    sha256 cellar: :any_skip_relocation, ventura:       "924645b5293da2413e4bcb68ca52a81eb6e44b0f6de85555fcdc420823eeb899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22f4d70227ddc707980e9fb2a7cdebaaf10c8a768b57c9ed4e4d2303a94c76cc"
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
