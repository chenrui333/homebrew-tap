class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.24.3.tgz"
  sha256 "cac6947b06e1a7a7e2c5d8a4d3a6fc5c72555959081e40ecac2776ed0f3a0eb2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66d60d793002904b6868c081f7d4c72510f8e5589b63668bae6264540944131e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66d60d793002904b6868c081f7d4c72510f8e5589b63668bae6264540944131e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d60d793002904b6868c081f7d4c72510f8e5589b63668bae6264540944131e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93fc702802b5a8d094db003a464e23bc338a200d9d93b8f946784bba97e1605f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a089005e44940ebe234437d00f6173ac29c09dd770b0720bc8015bcbc2ed0e"
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
