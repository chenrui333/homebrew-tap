class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.3.tgz"
  sha256 "804b0af1d69c1c5ca58589d0e32dc3d0b0fc791bfa70fe8c4fdd0461fed86660"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb7a675fd742dcda86d7093fb81e5ba74b7a6962cbdc69822da684520d61637c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb7a675fd742dcda86d7093fb81e5ba74b7a6962cbdc69822da684520d61637c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec6d4352ba1ef3c02b373be7a2c8d2a944799aa0db43625beea2bf5b5554905e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6d4352ba1ef3c02b373be7a2c8d2a944799aa0db43625beea2bf5b5554905e"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
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
