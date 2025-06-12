class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.10.0.tgz"
  sha256 "a41df46e439d0650f18538edaf4a0ee6fa914e61a645907832f797a97f565c3d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21014bb0c137e4056da132f781392f5bb99d95b04436c97bcf34fb5b863bd96c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa814f45631d40e784f20d0c4d19ef74ebb6ce51bf75850056a08dea7b6d0494"
    sha256 cellar: :any_skip_relocation, ventura:       "acec76e8b85d200c3eee110b27b14bd92a1b4c79b47f24af369094fc2ed5862b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41ebcb516ad00fd6eb94af32e6fd1d9cf36634fbaa07596c1c9832d6338e8818"
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
