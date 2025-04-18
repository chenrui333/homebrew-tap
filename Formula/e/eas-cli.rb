class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.3.2.tgz"
  sha256 "cf5ef7d147d497a6fefcde1dbd02200bbfabfca3a357074746f18cf7e0ebcdd9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b982294e372ab0adff87ca9994d017d69f1631ac74cb7cd58c11cd06b26b1f11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54dc409b9b10f71b87127bd786ead695c9d40b3432ed39096d39e63221f4b69c"
    sha256 cellar: :any_skip_relocation, ventura:       "501f8fe5d608e7cc29c1484da1100a9bbd855b37eaca8a4b39780a3c5262b272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3171193ec96db6020de65eeb3def61ab45bcc21cf7aee969829451505afc42dd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")

    assert_match "Not logged in", shell_output("#{bin}/eas whoami 2>&1", 1)
    output = shell_output("#{bin}/eas config 2>&1", 1)
    assert_match "Run this command inside a project directory", output
  end
end
