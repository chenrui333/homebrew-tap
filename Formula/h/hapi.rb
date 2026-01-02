class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.4.0.tgz"
  sha256 "8b2bcd864bd46caa337edb78d3249217a8f6ec87781e04a60f016710ef304b33"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "4b69c1e7dcc021e7abbf2a7aa4ec576fd0688231e9b9de8e55652ed555cc5232"
    sha256                               arm64_sequoia: "4b69c1e7dcc021e7abbf2a7aa4ec576fd0688231e9b9de8e55652ed555cc5232"
    sha256                               arm64_sonoma:  "4b69c1e7dcc021e7abbf2a7aa4ec576fd0688231e9b9de8e55652ed555cc5232"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c114a264ad0f67e89ab08306755df9c7b50451396380329ca98e71db8832d4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc4ee71079df535813f1180ce2d80bc626a01274291153551acaec11e7a49d22"
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
