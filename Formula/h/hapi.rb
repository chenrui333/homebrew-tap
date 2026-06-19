class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.20.2.tgz"
  sha256 "180c1867ef8730068e266054b3a172f89ab1d9cde67c31e9fccd59e68fdc285f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "63bb7b67b0dd880f3ace9d677e8bb24ea1164ad29cecdcd86181c7226d7e1169"
    sha256                               arm64_sequoia: "63bb7b67b0dd880f3ace9d677e8bb24ea1164ad29cecdcd86181c7226d7e1169"
    sha256                               arm64_sonoma:  "63bb7b67b0dd880f3ace9d677e8bb24ea1164ad29cecdcd86181c7226d7e1169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb0a361cd65b5fdc74cdd886e445109c631ab065f9137b14c233207481390f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a29c56e2d7979472d4dbced9418fc0397eb7633b06f3ac9afa934d65e14032b"
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
