class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.4.2.tgz"
  sha256 "f8c49e871842aacf902548f41528e8c813da655001f806a5fdc202896679a237"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fee36a7975e70501216b6e770a21658cda68d11741eb325c65397de86f664fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09ab18e1e0c660693822fc844f120a4fc5f67112acbdbad91c197abbf52c6af"
    sha256 cellar: :any_skip_relocation, ventura:       "b5f1e92a08644f6002466475ef10ff4b3421ae677ad9c9b6df8e928b18aaf809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5285b343bd6ef81486ec24222108053e447e89118875d32deea64f27fbb9a254"
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
