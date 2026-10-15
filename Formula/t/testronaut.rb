class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.0.2.tgz"
  sha256 "5aec86cb4125066356737db9beffcdc252e26c2767bb9bb747ecbbec6c167a3f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8232b1ff9d9b95de13ec516ad4a96f2aa24cc178a5c678246d15d581c99ab01c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8232b1ff9d9b95de13ec516ad4a96f2aa24cc178a5c678246d15d581c99ab01c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6d0b02c74f9965f23062093bafc7002ecd7a78d2cb6d6436518e54517cb503d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d0b02c74f9965f23062093bafc7002ecd7a78d2cb6d6436518e54517cb503d"
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
