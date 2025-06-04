class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.8.0.tgz"
  sha256 "f89c33334633c993bbf4eba270ff6026c189777b8cc8e9a45a67c9aeb6573c50"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda4838d6945ad7a4d7c80ea96a538f7503f3f52d6d3c7ebe1b0035aa277b8c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17d7ff63767645789d5e675241ebe4eb6bce19c99cfb6fd0886317d12ea35611"
    sha256 cellar: :any_skip_relocation, ventura:       "7090b87e7943d60e8ead1f8b7b80faf32f14afce52dfa4bc7bbe5e4c3b4953a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dae738cab61f82bf9cbfec3ba8b75cfe8cc36cef60f6594206b33ace51d1ce16"
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
