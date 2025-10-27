class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.25.0.tgz"
  sha256 "efdb080184a901085d410682b6b69b7f463073ec63f6f833105ce176b6accc9f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac53f3dfee3c28c49ca933469c008a3606e18859f0ff2fa07111cfd849688268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7855cc9373297ee1fd6a172a17e5dcf33ca879ef3a676f6f52a259c99837f1de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "683dc733e8015db5071edbe8fefa184dc55e3a67204c68a96307a033bee885bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85bd0f94deebcd7608cf167287edfb644e9d2d02ee9abcb5959b00f4967ccef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf8ab032c14806997b85e90f4cfc74b61ad097101a4525b7a1c947e43480543"
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
