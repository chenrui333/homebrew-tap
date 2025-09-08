class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-1.4.2.tgz"
  sha256 "f8c49e871842aacf902548f41528e8c813da655001f806a5fdc202896679a237"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9613d5f72d435f34d0861584b922236197104718db67a441bbe954e7c0c856c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "619c3e4b9b2b94f8e8da07b1e50c2494a5cd42f0bd9bae753d15efbb10d58da0"
    sha256 cellar: :any_skip_relocation, ventura:       "fdc318bfe92475e8eabbd380d6c5ad1fda53b658f6b899446ea861047421a158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ed274c68064bdd522a8857cd03a86e05532e1e60957bfb65e68da7296b69ed"
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
