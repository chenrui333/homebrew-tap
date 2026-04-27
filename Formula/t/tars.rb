class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.27.0.tgz"
  sha256 "5019c8bf268c0ef1ea63c3882224d1a1d026456dd4e771e05ed21437cddd4022"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5136a77fb630d7e830ac54333ca939c983cb88105d3b4caede9b61adbc7247c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5136a77fb630d7e830ac54333ca939c983cb88105d3b4caede9b61adbc7247c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5136a77fb630d7e830ac54333ca939c983cb88105d3b4caede9b61adbc7247c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1a5c90de02ed33a1593d8543f0cc9fb836c9bdd2a3e3590d9fee7d55855160a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a83e867e62534f1f0f23bdfaacd7fe81dc2bde98cb6ee356a6c60bbbb046fd0d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilds for non-native architectures
    nm = libexec/"lib/node_modules/@saccolabs/tars/node_modules"
    if Hardware::CPU.arm?
      nm.glob("**/prebuilds/darwin-x64").each(&:rmtree)
      nm.glob("**/prebuilds/linux-x64").each(&:rmtree)
    else
      nm.glob("**/prebuilds/darwin-arm64").each(&:rmtree)
      nm.glob("**/prebuilds/linux-arm64").each(&:rmtree)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tars --version")
  end
end
