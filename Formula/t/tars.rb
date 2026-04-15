class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.20.2.tgz"
  sha256 "026b020a7096a2694ec695c9849eb9c2027b31a81d63b7a7e4290326d20011da"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7311be89352c52e2071f528245f9cbea55edd75b3075f55527680d10a2575895"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7311be89352c52e2071f528245f9cbea55edd75b3075f55527680d10a2575895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7311be89352c52e2071f528245f9cbea55edd75b3075f55527680d10a2575895"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59869213e44f6744f2a04062d1f3c506d001b72bf6b918ebd388709a1908e149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c694e833c1328fff4aca38c5f9676d5f62855fea6025e261660724ffe54a8d5"
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
