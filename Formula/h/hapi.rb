class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.23.3.tgz"
  sha256 "00116d881f17e14a24544ba77455665b5b6a947508e054b4bba1dd66ac30f3b5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "95f76df9f6342a9ec27c62e78e4fb1e2e1715be25b7edc9aefbc3c6f971da2f8"
    sha256                               arm64_sequoia: "95f76df9f6342a9ec27c62e78e4fb1e2e1715be25b7edc9aefbc3c6f971da2f8"
    sha256                               arm64_sonoma:  "95f76df9f6342a9ec27c62e78e4fb1e2e1715be25b7edc9aefbc3c6f971da2f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23d169ce005a2048797be9f9753c5d8037467719e33a2293261b1980610752a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f81c1e2223801de6e7e4e46a0c71ee3083b5682154e6109aa8babadf088385"
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
