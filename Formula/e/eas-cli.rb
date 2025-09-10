class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.18.1.tgz"
  sha256 "f3a19558ca72d8e7d5be4a2313470e202a4202a3039cc8d9aec694bc44bdf499"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e272fc0f8ee41de111dbf3a3c9c239e4d0999649d0b212d904d9e43b69ace29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "927f0e3d765b163e0ce05a8233a38270a19b4f928f38301e0e1adca15fbcc857"
    sha256 cellar: :any_skip_relocation, ventura:       "cd6a3182e1cba68d518345d54601aad2fb065a3168b7d942f1136bd759b392c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f93ba2633a43b68fae02b57262168622644fbcf6e1edeac049d6953ac217c441"
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
