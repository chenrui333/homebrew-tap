class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.21.0.tgz"
  sha256 "aa8e4b75f49de86d39ca3c929b90a4ea9a553b52362efba6f904ebaeff07ebfa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59dad678d71a06fcc51d84789d5f8bf8c619e3a6ef4b63a3d272f6079356e602"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66a2ddca27216ddc450542434ddb0bc146ad7eb8724ae3123e76653ce190c30a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e14c64af912d6e1370506c75b27b4855929974d207c73aeea1d3e30ca4ae292c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "859ba9db3bf349192c5f69dccfe1545790836864818f4754783abee692f73dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88d83021c59884b8a4e56b89560655cd899f3d643418dbfb54578ae85765bfa5"
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
