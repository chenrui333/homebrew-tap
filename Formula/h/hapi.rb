class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.17.0.tgz"
  sha256 "8544b8c74d4360fd72b604c3091e93b935b689fc57edf4324eccd022181bbaa0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f0f5b682ac3926818f40647b08d45554b63647b50633c9616fbe55e2a2e37ad1"
    sha256                               arm64_sequoia: "f0f5b682ac3926818f40647b08d45554b63647b50633c9616fbe55e2a2e37ad1"
    sha256                               arm64_sonoma:  "f0f5b682ac3926818f40647b08d45554b63647b50633c9616fbe55e2a2e37ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92e9e2dec7f5f5c2b858c072c14123ee058ed32a980ea3b2a97062557e1824e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b95e3844a78daffa9b74fa4e7e04f3800a9cf20553d8ab9c2c53019cd0ff913"
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
