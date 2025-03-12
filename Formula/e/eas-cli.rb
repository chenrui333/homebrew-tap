class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-15.0.15.tgz"
  sha256 "2d8e2eb6c25d7352b32ba5f6cb16fe92f83e79c76d5712d52838be5011f43709"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5f87b6421571bd926d96671729fa4e50238d77003a6ac038b459a9b9b02ee10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1079157bd3386d39da975f5fdd2b9d9c47c71908147b7e16fc5c60d63a8e12ac"
    sha256 cellar: :any_skip_relocation, ventura:       "9609f929b59eba849c984c306292e3a277bd0d3ddccda5f34d8b42e99e729a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6350bbc1377d7557d6ad7c75b4db3d91ad54cdbd5728be5b7090c3850e98c61d"
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
