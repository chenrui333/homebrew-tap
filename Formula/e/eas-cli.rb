class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-15.0.14.tgz"
  sha256 "588ef3b4f92f436de4deee399a4cf0de9a4676cfc9a31901b140e0d10e19df02"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dbb578ed03ffd7d5ae7e2f4348f05ab3f0fb595540dc77cb214425e39489a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fb8f43b2aca1d7ac827ba8cc69deeb87c01fb6ec298745103ed04c2da765cee"
    sha256 cellar: :any_skip_relocation, ventura:       "1defec86fe4f8f03edef35c3c3b7b20ed41d031ed72382f22fcbb070a1383fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cb9fbce27cd2b4c4a320bd5e4309f564bf167882b7a7ce717f30404102d7510"
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
