class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.4.2.tgz"
  sha256 "d31052427bd6fc683cba38f560ec00f0c2113d0623889d84afb02ab4eafd28f9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f936da2e3168a45a2185ac17b64da3ea791404d219307542c55d2dbed228352a"
    sha256                               arm64_sequoia: "f936da2e3168a45a2185ac17b64da3ea791404d219307542c55d2dbed228352a"
    sha256                               arm64_sonoma:  "f936da2e3168a45a2185ac17b64da3ea791404d219307542c55d2dbed228352a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e6537e4b4927851250ab7a6ed20bed75d8605da32d2c05a62cedcba06ed9c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faf150edf603b406dd7fa43c92d8212f3b7b13fae6f6bc3b4021efce2a353e3b"
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
