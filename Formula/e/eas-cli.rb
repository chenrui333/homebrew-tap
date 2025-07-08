class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.14.1.tgz"
  sha256 "684a07e1829ea125aae134f04c63eeda1e511db5869875fb4db972e015808e9f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "528059796e278c9d1d41c8ddead8eca1ce7a53777299e1c1abc99c02bb3e8adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e89019071e575935c5dce580306ab27d77b96723d38022b3322af8f11e550e93"
    sha256 cellar: :any_skip_relocation, ventura:       "594e504b1ab9a1cb4dbd6fdd3d0ac55656f497ee547e2b43e0467c155397b5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d257ee17955f8c399a594e1c3845c2809483dbdd9a9bf6d59a964f2f3c61d7bc"
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
