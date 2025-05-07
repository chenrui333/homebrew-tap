class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.4.1.tgz"
  sha256 "08b633d9ba5e37642d701cd4782afaca057b56536b388f03c1a391cd22a9164e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afc90a2ecc83c1ca2ce05f842eba61f19f292d7159430409e441d2a6457f4fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22a455c9ef61fcb1505e8ee477d4778e594e7809d429273c48983287c548ee0d"
    sha256 cellar: :any_skip_relocation, ventura:       "df043934ab953bcdd11e412a82a897e53fb9a0ddae7311fab7bce51f66cbb258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f3e9260c8e4c3c985b256246236199ba6c01f068552f222f1347acf0860217"
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
