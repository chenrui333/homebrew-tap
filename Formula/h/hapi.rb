class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.18.4.tgz"
  sha256 "50a53abf55aa71d5f168509ced049169547936c70f5b817aed5fb765900df5ce"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "42268d63542f5440f7c32f2f31576a9bc53670f1276374fa40a3e55efac1c7db"
    sha256                               arm64_sequoia: "42268d63542f5440f7c32f2f31576a9bc53670f1276374fa40a3e55efac1c7db"
    sha256                               arm64_sonoma:  "42268d63542f5440f7c32f2f31576a9bc53670f1276374fa40a3e55efac1c7db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d54579e0454e64efc2e3532cd123dcbaa3a9b600a3eea0c0f151d49da47d0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3414a35cee762e4546e35eadbcbc5d53e538accbf10d862017e8c9e31d5d9cd7"
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
