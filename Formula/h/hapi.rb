class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.15.1.tgz"
  sha256 "2d1ba68675875bd3a12c705984a772cedff1d82d85e89750d6bf7439099e5126"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "fe7375b454cb3d53cfedc2a2e08beecda013cc1a7420c601bd9f021f784798c3"
    sha256                               arm64_sequoia: "fe7375b454cb3d53cfedc2a2e08beecda013cc1a7420c601bd9f021f784798c3"
    sha256                               arm64_sonoma:  "fe7375b454cb3d53cfedc2a2e08beecda013cc1a7420c601bd9f021f784798c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7880769d0134bdd98daabc188c7689e9d097c5be496424df7fbe521a2d07d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cfc097136cc1e99a1facda7cd8421a58c660640673a06116e5a12e2f743a410"
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
