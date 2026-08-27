class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-22.5.0.tgz"
  sha256 "9c89e6fad5a64f03308ae4c700afea37b00dbe29a05f63143a990d596184522d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3957a6db50ca3921102ec22f2040c43f7ef0ab544e7df0d102a2896d43da2f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3957a6db50ca3921102ec22f2040c43f7ef0ab544e7df0d102a2896d43da2f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5312fa6208250d075072413c385a01ab11c723dc3de5fc90307c7590635942ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5312fa6208250d075072413c385a01ab11c723dc3de5fc90307c7590635942ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5312fa6208250d075072413c385a01ab11c723dc3de5fc90307c7590635942ef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")

    assert_match "Not logged in", shell_output("#{bin}/eas whoami 2>&1", 1)
    output = shell_output("#{bin}/eas config 2>&1", 1)
    assert_match "Run this command inside a project directory", output
  end
end
