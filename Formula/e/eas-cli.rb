class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-15.0.12.tgz"
  sha256 "72134bb1415fc5f8971ffacfbcfe14d4132c196ca161fdaa16744cfb56f3a95d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "822ef06607dd19a38445b62c40521056dd03fce01ba315b56e4ae9ff927f5916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89acfdbea9854fa77aa8ac958d9908139cd6ba696a9330631b9bba5085d4900d"
    sha256 cellar: :any_skip_relocation, ventura:       "490441b5193cabdfe829a1cc0bf7c50fa85f0b608d7642f1e66aae4773a3bf8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1721b2478a32c61b7ac1b75e1cb64afa3113a47af267bbe54c5b7cd9f87b860"
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
