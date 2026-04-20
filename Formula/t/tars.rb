class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.22.0.tgz"
  sha256 "3e78cda5c83d520a044690b55449fa9be9f4f88bada227a0369719f724c49149"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56f977c38be9e868c7418254d55f8b6c07f1e2e6eb7f742336eeebbd7e960a9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56f977c38be9e868c7418254d55f8b6c07f1e2e6eb7f742336eeebbd7e960a9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f977c38be9e868c7418254d55f8b6c07f1e2e6eb7f742336eeebbd7e960a9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6da0fc096a6b5dded6f4c7d50007e6cfb483ed0e19de24a33619f9af4a5a975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f9e48f9802669cfd0184b31f13dd01668301bbd29a96bcf6b26e9f491ab31b5"
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
