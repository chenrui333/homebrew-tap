class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.23.tgz"
  sha256 "75155bb78a0d772eea074d1d423e2cec3bb5e407d882aa45b785ff2ac7db1495"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe4d45fa51db8409f94ceb53aae5ef0641f8885cde7a87269f086d3634ae1a0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4d45fa51db8409f94ceb53aae5ef0641f8885cde7a87269f086d3634ae1a0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5139cc5ef10581345aeda855efa6c181fc4146f410df9d0e3b8bf245a93d07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92baa00a3399f30bb1285eb9a4dbbc3cdf9de91a561cff7b7e2f20a11474f082"
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
    assert_match version.to_s, shell_output("#{bin}/newsjack --version")

    output = shell_output("NEWSJACK_AUTO_UPDATE=0 #{bin}/newsjack doctor --json")
    assert_match '"root_ok": true', output
  end
end
