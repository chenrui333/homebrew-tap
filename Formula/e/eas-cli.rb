class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.13.1.tgz"
  sha256 "15367bb29a8f502469a55d24d27303a310a1def015095413b789a94df8a348a1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0ed04457c791b8a2a15eee33769494e3019c4abcb4831aaed944fb42d7391c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "429a2e511cf189356bd29867d616989dc80c65be377526f4d0c6a62d0cd0ed81"
    sha256 cellar: :any_skip_relocation, ventura:       "e18f961a06eff4b7df04ffc395205a8f4d484c5f605004dff237837269cef01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f14d9cfabdad1de739e9752559d08807723d839e8d3b7f1705048c6f85ceaf"
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
