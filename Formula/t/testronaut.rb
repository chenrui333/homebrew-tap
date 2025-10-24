class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.2.0.tgz"
  sha256 "89b115273b0e9285c30ba9c79b75c09a73b90985de87ed66bd7c97c96980302b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58d47ce65a267ee5d3410b2fd041338c5fe5f0bb90a5c23c4751c6b674ffcbd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d60e75230ff31966e6dd3164d13344eb257a127b229d43ff4660dac9fd4b8e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13e7cd5c69f37c5130727c42ff75b981d58b3f7604d341d61f555c19f50dc995"
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
