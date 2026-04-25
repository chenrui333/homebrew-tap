class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.17.0.tgz"
  sha256 "8544b8c74d4360fd72b604c3091e93b935b689fc57edf4324eccd022181bbaa0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "ac392f790c0b44802183acff893cff3218f17dc541a5bbf6fbccc9426716c096"
    sha256                               arm64_sequoia: "ac392f790c0b44802183acff893cff3218f17dc541a5bbf6fbccc9426716c096"
    sha256                               arm64_sonoma:  "ac392f790c0b44802183acff893cff3218f17dc541a5bbf6fbccc9426716c096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "035e3e2742ed2aa6f5cae4191135a9dd793ce83fd084a100deee76d69444694c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d53d31f72570a28f8e50605e088a72d627e158437b5e137a5968c32488b6b48"
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
