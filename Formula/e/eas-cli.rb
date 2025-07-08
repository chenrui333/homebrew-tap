class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.14.1.tgz"
  sha256 "684a07e1829ea125aae134f04c63eeda1e511db5869875fb4db972e015808e9f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73c54f71d0e42521a43d29a5531f864e49bdcf48eca2944e4c769d3d92491f7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34d424447059ef460ec20182e3ea1a46a55a2552c99b47c212298631d381b170"
    sha256 cellar: :any_skip_relocation, ventura:       "ca28c84b2612e059874d840c4530b51f08617c3af13d674fb558cf74b6e549e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e1b75f27c6d9293c4c5f16c210257736e92fe4a98bcd38c496f43cb0d185c5a"
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
