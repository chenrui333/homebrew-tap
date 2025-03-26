class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.1.0.tgz"
  sha256 "50f35e39903d5e39f76eb068aa085d3ba68b70cba96eb58b65c8cc1368d503a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7052836495fcb6216825f6ab2c68aa383ca29b35d97bed42dd580f4038728b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b06ccff516ab169b1b9001aa537dd6e54cd7829da8c014f4432509701ffbe66"
    sha256 cellar: :any_skip_relocation, ventura:       "d61c9523dbf8e74489e896ccc8e4ae17290da51a2dd008fa5c06d8af4d1f9948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff70d026e7feffb716ca8d9f06ccf40a13028b13523c4d0d96368b7414fd123"
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
