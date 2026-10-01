class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.10.2.tgz"
  sha256 "3bfb00e378bef53a58b8d8c068ad591359680ef7f8a71de43dbcb298191b9747"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19dcc291dd7f769befea9fce7fcdf8dbfa73092957efaddff6efab367e9e49f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19dcc291dd7f769befea9fce7fcdf8dbfa73092957efaddff6efab367e9e49f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e5360e2edbfc514c93b97bed0078ee0ea43d6931cba88d92226929496ca4f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5360e2edbfc514c93b97bed0078ee0ea43d6931cba88d92226929496ca4f32"
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
