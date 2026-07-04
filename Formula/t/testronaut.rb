class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.4.0.tgz"
  sha256 "abcfb77feda7faa6f78043d010afd2e8013ec3e3bccddd4e2a8d58556096582f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69004d698b7c64c3ab2d2bc8914b48073142ed774e42694f8d7612782c00929f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69004d698b7c64c3ab2d2bc8914b48073142ed774e42694f8d7612782c00929f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69004d698b7c64c3ab2d2bc8914b48073142ed774e42694f8d7612782c00929f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "997a5dd37ff7583502ca24e2e8b081e18db744b9e98859a17a0b8ba6207fb771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "997a5dd37ff7583502ca24e2e8b081e18db744b9e98859a17a0b8ba6207fb771"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "Missions directory not found: missions", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end
