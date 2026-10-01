class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.10.1.tgz"
  sha256 "c7597d4ba2c2278d11abee058bd9f7675a86e6d1b45011aa36ccabbf0f39942c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8dab9402c1acffca958db8ca109881ac48654791910bd920d64fb0ac4e9e70f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8dab9402c1acffca958db8ca109881ac48654791910bd920d64fb0ac4e9e70f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c82a26c8b6830c262c944069918c622d84614a1766e5e8c3805d9a8fef19a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c82a26c8b6830c262c944069918c622d84614a1766e5e8c3805d9a8fef19a08"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "Missions directory not found: missions", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end
