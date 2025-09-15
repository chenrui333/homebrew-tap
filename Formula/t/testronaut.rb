class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.0.27.tgz"
  sha256 "dbdd0804064757493781cb037008aae98014b62af20be87e839060aa4fc776aa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba23668933033670b0673b2f0c67862188ef93a744333bc3a109993903bde571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766eed2588b0f6d628a65b9a6b8d9f3703b33b5524f2f395fe4da40c5feaf5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae54b738f6c7e6fcef5ef5c34f22d01c683a4349f69f108cf1743f536b32d707"
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
