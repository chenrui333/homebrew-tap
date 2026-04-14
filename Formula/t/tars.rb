class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.19.4.tgz"
  sha256 "9628bf1ba896fb50f10a6ac9f5a65b5f538de0316574041ffaf22c65b505ed27"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6bdd6dd1dd30ea6f3bc7170717e40319ca4784d9aba2aa4796ce7001e9b0495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6bdd6dd1dd30ea6f3bc7170717e40319ca4784d9aba2aa4796ce7001e9b0495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6bdd6dd1dd30ea6f3bc7170717e40319ca4784d9aba2aa4796ce7001e9b0495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f03de86a728f07b97ecc2528a4d982a2ffdb2f4637d7f00de4b6b7903226b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83a48644b9acf19a9e4d01bb07309be32630421615924fe78efbc0832d70082"
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
