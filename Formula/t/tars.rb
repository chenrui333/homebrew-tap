class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.24.3.tgz"
  sha256 "cac6947b06e1a7a7e2c5d8a4d3a6fc5c72555959081e40ecac2776ed0f3a0eb2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e9d2532817987d535cf500a8a563af3ec80e621893de2e7f52f082fe4cab135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e9d2532817987d535cf500a8a563af3ec80e621893de2e7f52f082fe4cab135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e9d2532817987d535cf500a8a563af3ec80e621893de2e7f52f082fe4cab135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21c64e07e0df7e8a60a466163d0b53ed9cff2d57816db1271317113b9df94ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7507590f4dbd4a1fef846f81edb6dc0073b5562ce134857a59be99bb6f435e"
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
