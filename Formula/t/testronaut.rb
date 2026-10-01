class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.10.1.tgz"
  sha256 "c7597d4ba2c2278d11abee058bd9f7675a86e6d1b45011aa36ccabbf0f39942c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54b60d2b6b6d7254dc52b8f4dd0e3a453027ce7676d685126b74a62c0abb55f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b60d2b6b6d7254dc52b8f4dd0e3a453027ce7676d685126b74a62c0abb55f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ad7e7e4c0b7278470bc8bd94dda3666c5d133a4ec5e379d2f225bdc57234811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad7e7e4c0b7278470bc8bd94dda3666c5d133a4ec5e379d2f225bdc57234811"
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
