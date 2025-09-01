class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.2.4.tgz"
  sha256 "51054ba53521a0d5d62139673399dcdedec0a5c38cc5dcfa2f97b195a00b4280"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9858cdddbb67c13545dd051dc270b358169101f3d179faeee15e7598df3d9cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83a5c08d1fd12af0da596edb8524e2f4d8b72e20d32138b2f75d44ea65c2362f"
    sha256 cellar: :any_skip_relocation, ventura:       "3caadfafe78a013e28dea57f911686eb1077defdcf10172b1329711987218bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f042de99230d8b31c2e67fd4cf21e0e76927c031b4f2099094c6c36b9b37a204"
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
