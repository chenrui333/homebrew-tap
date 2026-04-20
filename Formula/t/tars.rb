class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.23.0.tgz"
  sha256 "364a8f07721bdb7fab9d8265d35d581011f781ef7fac5c64ea38503e76a76449"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32d450f6d66149a873f9c7e81eaf8cc390c657e13b879705f6814347f0fa9269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32d450f6d66149a873f9c7e81eaf8cc390c657e13b879705f6814347f0fa9269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32d450f6d66149a873f9c7e81eaf8cc390c657e13b879705f6814347f0fa9269"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a93be749b8f517ebd83b6ea7f221f8ee2f0cd565022d05b1986fab45caed9bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7d22a0c42fe4d0ef17c5fe51413f2e5e26a7a253955283d9625a7c33199138"
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
