class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.7.0.tgz"
  sha256 "ad5b2336b96a274b682016695b36d8f4c86d6ef6ed088b55a7bd75f4de5e41de"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "44917dec0a629befcef0e2d042eaaf0512b731dccef9b82cb2347b419ce402dd"
    sha256                               arm64_sequoia: "44917dec0a629befcef0e2d042eaaf0512b731dccef9b82cb2347b419ce402dd"
    sha256                               arm64_sonoma:  "44917dec0a629befcef0e2d042eaaf0512b731dccef9b82cb2347b419ce402dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c23efa1d4159c09a1a53705e62528a928922f728952a715934a6b0051a55711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd456920e51cf1a63974d90f3307a2d2c9fcb5a7312b8b57004760b29fa50440"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
