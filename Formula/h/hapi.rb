class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.7.2.tgz"
  sha256 "58a435ee210b4f57191d934eec3613ec419318153a251d4523fb1de2ef770ffc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3baeb2287199e2b7b8dc66734712c91a93ba98bca63c910e4c783be3db2db373"
    sha256                               arm64_sequoia: "3baeb2287199e2b7b8dc66734712c91a93ba98bca63c910e4c783be3db2db373"
    sha256                               arm64_sonoma:  "3baeb2287199e2b7b8dc66734712c91a93ba98bca63c910e4c783be3db2db373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c6ae3f8d31f6d53691b7ba809fe4726d79736c65b2903aecfcaa37813ff889c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a3e57adabfef8c65688208c6c282d87268e46659f9d85336ca38eb9f18fddc"
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
