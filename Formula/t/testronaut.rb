class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.12.0.tgz"
  sha256 "68412678d07166385aeb2e28212d0607027780dff3daf8b8c3c1a0e5bfdfe149"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa910a5dc778a94de68bc976416ead3af63309bc19028cb6bf802c269bfb1298"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa910a5dc778a94de68bc976416ead3af63309bc19028cb6bf802c269bfb1298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d54910a66cafcbd7573d932fbffd2e218ed82e0a913846ce17d3ea49dbf538e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d54910a66cafcbd7573d932fbffd2e218ed82e0a913846ce17d3ea49dbf538e8"
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
