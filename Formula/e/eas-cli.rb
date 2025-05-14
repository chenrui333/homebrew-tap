class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.6.0.tgz"
  sha256 "15beb80772156a5716a4c582e19e6ed5183b8cb600d0f75d76f1f6c49e697d4e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4855f49d8c497f0e2a0602bfe739b1aaeafdff3f3f0ea77521f6673f1c381023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "052f64a2a92abdcb0be45a3480e08ece0bdd6fb17afc5d31c7ab46bc891028eb"
    sha256 cellar: :any_skip_relocation, ventura:       "7b7936ab374ddff9285d13cccc969c5f2501588931853888c3822e38f6eca0a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d14a6e3f1a0236eeddfc2718bfdd099b8ecac7b176dc617040dda9e48aebd320"
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
