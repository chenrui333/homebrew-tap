class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.4.0.tgz"
  sha256 "d1074b846adb72c4e82e75b0b4bb06939dc1d19af770d42b1957788b0e2accd1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71d4b45b8866be28ae0e481229713bf522995f1ba701257a5540fa7970d09f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3ca20d70fa38a4e3415a23e860b6f0ef20492c96af41184c1c60a8640bf91b"
    sha256 cellar: :any_skip_relocation, ventura:       "6501062fbd8d237b163d744eef2eb7e5bea4b475a4d071a89c7ab91ad46f92ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3c56650cf60062d45ffce1ee04668ad0630938c2fed292b93d52d62eb36409f"
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
