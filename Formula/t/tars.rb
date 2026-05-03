class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.28.0.tgz"
  sha256 "94cd1aab4b63dafc231fe2836f29014edbc2fde98390dd7ab5c7a78e09958a80"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "730a2913ea6c76d5ece856ea8fb28c6fb34252c00476b636302e5f3c81c8c88e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "730a2913ea6c76d5ece856ea8fb28c6fb34252c00476b636302e5f3c81c8c88e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "730a2913ea6c76d5ece856ea8fb28c6fb34252c00476b636302e5f3c81c8c88e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "226194f77a07389ac976ea1e8e7a107d245124d2ce1acd09ec5a57da26f6306e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1172c25cd6e9b6080885befe6372f85c94888debd3de7af1cc5a6e796032039b"
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
