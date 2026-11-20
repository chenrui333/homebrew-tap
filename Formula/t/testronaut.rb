class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.11.tgz"
  sha256 "06892accebbe94f763b4f5bcc0d0a9f33338ab5c5a58be241d4a9cead21e7ac1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e45007b309210a5c54975884c4bda8d33d8013957ab470c427be91fee0f98684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e45007b309210a5c54975884c4bda8d33d8013957ab470c427be91fee0f98684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3beb40b413b289f8153ebaf8b7b1576468d58e5c6bf0a5024fa85dc3f7f8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f3beb40b413b289f8153ebaf8b7b1576468d58e5c6bf0a5024fa85dc3f7f8b0"
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
