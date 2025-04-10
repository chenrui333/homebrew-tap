class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.3.0.tgz"
  sha256 "129b76026e41cdf862855dcd655fe35ca16e4d5f3f90268027bd3f911109859d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c02bbf343951fd9adbd21418240126ce30b05007a720bcfa50508df3a044013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a83cf48ad876bce765a9335c118088d1bbabf05211d23e8df2590e61701d72"
    sha256 cellar: :any_skip_relocation, ventura:       "02dee32d95c9fb7a2011254fefebd4fa37836c0aaea03f98d6f28d9ca4f66561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9129498d1ca301bbff0db4ce3928e711cf36ee97ecaaad9ea1c76daf2e6961a"
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
