class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.29.0.tgz"
  sha256 "d5e59110d6fa217f945148d6f773f30810974afc9da57092dc01757eda280e92"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "dae8f85d7c6afc56a584edea1399a72161d7ed27bc5ba9d1b27ac791fe69f123"
    sha256                               arm64_sequoia: "dae8f85d7c6afc56a584edea1399a72161d7ed27bc5ba9d1b27ac791fe69f123"
    sha256                               arm64_sonoma:  "dae8f85d7c6afc56a584edea1399a72161d7ed27bc5ba9d1b27ac791fe69f123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e77d32405acfb624e11e84411aa13457bdfa6cec07aec44f33341261b9ab5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c6edf45f758242a6d73dade0dd8636abe1f8a34b42c29af92832eb4c83a8bac"
  end

  depends_on "node"

  def install
    # Required for the platform-specific optional binary package on CI mirrors.
    ENV["npm_config_registry"] = "https://registry.npmjs.org"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
