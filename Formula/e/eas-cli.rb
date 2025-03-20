class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.0.1.tgz"
  sha256 "f0958e3de11d8c97a7f72451fca6257f64fe3222aa978b599fcd753006983c8b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9840d55f3a852a964596077a132d23ad9f991f560dc90734dd1a69f74ff8af1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "806d4b29b04525b142f7d8b37c245049050c36168d58f5d842289f7a7ab57ec7"
    sha256 cellar: :any_skip_relocation, ventura:       "57b2e3b0985c665c2042a2adfc253a5cd84cfe36519dcbcdbbb3bc18dac2dfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b685e4ce75a8c93d287790cfa389f2cc5b5c00bca0bbf8dba5bd06ccc1240f4a"
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
