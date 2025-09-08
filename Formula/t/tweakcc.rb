class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.5.0.tgz"
  sha256 "4c3cf73dec88780f3ccc6646610ecc8c3822a9a0d636039aec5945e451938bb8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27a09def7d56de0fe1d744dac8f839f2ba2107d41a1105b971bd9a6bcc80612c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5473e26265673816d7e40df925382e04f71cdf1681c668aad3b8ab71959708fb"
    sha256 cellar: :any_skip_relocation, ventura:       "56c9b0339f2725f3f411c398eb30548a915c0fb4350f52bf17774715c1e65934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7313fe3b148fc85f860579343be8b2f33a92eb56cdbe426f5d23f0a5cc223d34"
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
