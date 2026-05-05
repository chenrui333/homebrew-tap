class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.29.1.tgz"
  sha256 "53ffd94c7ab1921440e3ff8a193c508158abe15e8f6cec9d9a60641608f0ebcb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd09479e9eb7e02e001f8c17d11175e5e97b7468fe0ba7bc30d8e4b726d0a106"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd09479e9eb7e02e001f8c17d11175e5e97b7468fe0ba7bc30d8e4b726d0a106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd09479e9eb7e02e001f8c17d11175e5e97b7468fe0ba7bc30d8e4b726d0a106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d48bbb804bd5fbde901f36c36cab5b056aa5e4711e0c3297568613b80349a881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94c2637b3a221c68fb3171bf677550323cc8823a025030964778a55656559fbd"
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
