class Preevy < Formula
  desc "Quickly deploy preview environments to the cloud"
  homepage "https://preevy.dev/"
  url "https://registry.npmjs.org/preevy/-/preevy-0.0.66.tgz"
  sha256 "aae290aabc6046dc7770d853888dd9a7c13e57f3aa68397e249c2af608fd0460"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "9836e4376d830b2420ed6e756626d153387672223dfc68a0d2f1fa15387b5cb4"
    sha256                               arm64_sonoma:  "1032f1612994633997bec4bc76098de150e2a9b42372d7af109ffc1cf8fca9ce"
    sha256                               ventura:       "44c65e65d6bcf5adec69f08d6538c03573fa1a986de0689a7921b2bf4dc0ae43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a86e1805b49e250706cbca535dafcac67b89908a25dc79ff30d06e59776ebb1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/preevy --version")

    output = shell_output("#{bin}/preevy ls 2>&1", 2)
    assert_match "Error: Profile not initialized", output
  end
end
