class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.6.2.tgz"
  sha256 "79096f68a9b85665b45382255252e0a622bb55edaa1f5907c4f9216a5d770c73"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aae175c4a60c226fff17121a310235a66e6bf44aa41ec1bdd94b7b88cb069960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39c48e339322354aaa7dd9dac87783506ecbba02bc7a5661e8cb0eda97a4bc11"
    sha256 cellar: :any_skip_relocation, ventura:       "9d52e312bc8191f628442463a3ece3e6deb47106fe8fd7851a2f8b41d4f30b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f10ef7fd442437f0f942a599100e02f76d9bc0ad87c504b37fc952c858d1e9c"
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
