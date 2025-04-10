class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.3.0.tgz"
  sha256 "129b76026e41cdf862855dcd655fe35ca16e4d5f3f90268027bd3f911109859d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bfed54b945d99dec033b76a5b83e3b7ec54feec5ec0c8865daa57b3e7c6875d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07362fd1700ff7d549c64e68b9fce8c63733b5540f87fe3d6a40798dbb8f7144"
    sha256 cellar: :any_skip_relocation, ventura:       "7d1e4d4f2840084b8f1fe9ca8ea6530585a60574f16364c4941aa9f00bdf5e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b30ae2a002b51347500f66df9a49d5bc527b9d056c0242864d7c280be9ff5b1"
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
