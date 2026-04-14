class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.20.1.tgz"
  sha256 "c66e6dd9dd91b4358ce0f11b7983b80b0afc1d6b7d7b3fb41f18e58af04a98df"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15f66e34844d07920f89fd3e9fc8bdc281d1b535bbfc2b559b4deca7c1513d44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f66e34844d07920f89fd3e9fc8bdc281d1b535bbfc2b559b4deca7c1513d44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15f66e34844d07920f89fd3e9fc8bdc281d1b535bbfc2b559b4deca7c1513d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a1db0cd089312b80a190181116914f604772a1a0f698c8f341d62cb37233884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f9477574dde0fcda36f373e38ae06caa69db8a4e4151cd2b28034f428d26b1b"
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
