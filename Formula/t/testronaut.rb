class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.1.1.tgz"
  sha256 "deb34cefe8e30edc60f456f4ed090154830efe8dbb07b77e1af030e39e280d14"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1358f437d22b14ef45620a79efbad156ddcb71d2b63b515efa57e490dd26ea89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad140c2ae68d0369c6bd02af1d5028f4d743a3989152ccc07bd1712bef406581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a56cde489952baaf947a0714833177610d776c97845a5e19f25360293cd8da5c"
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
