class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.7.1.tgz"
  sha256 "0774b284f01bb3aba20de264e20edffaa01cfbeeb818a63826a77700bc8244f6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2793bb7df362cf7154bdf631c24647d2146ca66dc2ac7e48a14e1115610d316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ebc5148c8ff1b9dbbbb99543a3325a7a5e4ac7464c8c984e9f8e29097c1ad4"
    sha256 cellar: :any_skip_relocation, ventura:       "36ef5468788d830dc4b46e4ebd6e1f5a25aee5c094922346f1aa31f8af1b1d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b161866a3c8c9a124fb996e2c1d85409ef5ba4f458b76f1119fc1327473f6060"
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
