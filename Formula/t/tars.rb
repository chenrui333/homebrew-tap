class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.19.4.tgz"
  sha256 "9628bf1ba896fb50f10a6ac9f5a65b5f538de0316574041ffaf22c65b505ed27"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d8c5b72bb258d7675934678cd9c69344754fcd5ffd6cd98e12e44739c2c5420"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d8c5b72bb258d7675934678cd9c69344754fcd5ffd6cd98e12e44739c2c5420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d8c5b72bb258d7675934678cd9c69344754fcd5ffd6cd98e12e44739c2c5420"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a2cc9be5f11faa32415d7528e2cc698ec3fddbd1d7cb181b9a5153b5427c868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e19ab632c4daa40b2fc26e89b2df5cb49d264f1e5d9f2d747219b01fe19e8c92"
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
