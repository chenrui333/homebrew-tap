class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.0.26.tgz"
  sha256 "32f244c72f59a4e2a02d9b6be2fbb39d15007fcbe22f00dc4428eddc54ac7b0a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46a11b56a9018020e07d19b5cd9b0f4e4ef2deb71fa5cb2b78accc9c3394b605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7802985632c0d5b3cd14808bcc5109ebebc0e31c202a420c28f3b81bdb60228b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc72b60a058f3e8644bf3b257cac348d7072b72f2b5dae1cf711c0c27d08eae4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "No `missions` directory found", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end
