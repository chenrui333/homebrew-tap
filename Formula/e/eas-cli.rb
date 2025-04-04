class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.2.1.tgz"
  sha256 "f3e4528dbfaaf3864ce4b9f1e0d8eafffd946bb87fd5a7262d241c9783329acf"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43690a790ec0907f1ef8925955e1953ea0f2e6a3582585bdc0527021abd03414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4166b8aa62cecd2194674a83fcf0ec9157818615e6977575658571b92411edc"
    sha256 cellar: :any_skip_relocation, ventura:       "3df66f3d06f1d294de28636f952b4be293e601127e0427cd9776dac425f8d027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41758ca6e66c04780584caa3eb13b38b3038f0a7eed2ff70f273dd0e31adcdc2"
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
