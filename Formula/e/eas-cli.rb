class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.19.1.tgz"
  sha256 "632e14918ff0dad90640b45605038a6e31b9b8669a31d33c1ac565ed2de1bab2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "168c574836757b4f122498d428581a0f7eff38274805801e4d417f6ef2c440e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a598750d2ef4ac2896174531ee618d5033963af6b7855bfa9fd088151f9fc5ab"
    sha256 cellar: :any_skip_relocation, ventura:       "1ff8bd4814efba56b6dcd3a5047bfcf7a81b86d5fc110116ab46e829eccfb7a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ea75c879697b59afea4ef35d2259af1212d7fc33077d12a7c01e6a84c46fea9"
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
