class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.28.0.tgz"
  sha256 "94cd1aab4b63dafc231fe2836f29014edbc2fde98390dd7ab5c7a78e09958a80"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25bf2459e97ad0d2208803c8ef9c72c10511d53f44f3178fd1063b51299fbf41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25bf2459e97ad0d2208803c8ef9c72c10511d53f44f3178fd1063b51299fbf41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25bf2459e97ad0d2208803c8ef9c72c10511d53f44f3178fd1063b51299fbf41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e6b40741c8e954f3fe344ba5f9f20054cec5df8e3c7df367e3a9d9ec0b0f4ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d27480f73e57475250a976e9bea2b6aab62a249d9344868591fea9e3f9369e"
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
