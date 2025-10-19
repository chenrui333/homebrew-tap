class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.24.1.tgz"
  sha256 "fa3dc474ac61d7ac9e7c65169d2fd9e5604e5efa9f80ea5c248a9d80b82ab0d7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4be477f557711b96a7d7169c63b6eb22284b0db65dcad67c8834c969f1307446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "935031139b0be152504e8519b518933553f84e14fdacf1b1179bc3e50c89f112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c6184eef63e7d4e0a12b6bcac30da5c5e1ef0d41829f267058dc3d639765a9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "704451145421006b70283741112456b113d8ff67f4148bd66d1bb8b90b653485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6c0e437ed587bd5565541480817d9d0e969abe42355419cf17f42eef43b6fd4"
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
