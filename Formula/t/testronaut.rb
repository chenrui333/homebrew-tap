class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.3.1.tgz"
  sha256 "418eb1ba54785f748a25bb44065f2e3159dbeea30dc73c3ad00c5b28c0c9b40f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a0a57b5607b36f43651cdd068e361a8c6a579801443e86c74a96b4dce0cca4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a0a57b5607b36f43651cdd068e361a8c6a579801443e86c74a96b4dce0cca4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a0a57b5607b36f43651cdd068e361a8c6a579801443e86c74a96b4dce0cca4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b0c12fc77835f596caefeda272d69bd3851fb8fb924bec22170576e9d2ebd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b0c12fc77835f596caefeda272d69bd3851fb8fb924bec22170576e9d2ebd2c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "No `missions` directory found", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end
