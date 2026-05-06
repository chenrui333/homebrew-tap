class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.30.0.tgz"
  sha256 "1543f9068d21069b6f45d5a436667662b840aea5598a473818588273e3093df2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45506ccfb33030fe692f2d0f32377f911662f7b05fd8990478e50a231a3ccf30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45506ccfb33030fe692f2d0f32377f911662f7b05fd8990478e50a231a3ccf30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45506ccfb33030fe692f2d0f32377f911662f7b05fd8990478e50a231a3ccf30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a7470a9bb4ccf44b7f60efa5b46737569f880a1dc9148f076e4b645a9abd8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "947da8440953e2648addbe18653c9074088eafbb132fdfbb93b76c5dab6fdec5"
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
