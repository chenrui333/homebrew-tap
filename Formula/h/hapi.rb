class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.23.1.tgz"
  sha256 "344421e42c68d6011c325e344e915e95b973ca111cf96671a4e1ddff5b65617f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "162fc180bacd0ee2e086581e180bd70f20b8ffec1ac9920686f2fbf6f701c33c"
    sha256                               arm64_sequoia: "162fc180bacd0ee2e086581e180bd70f20b8ffec1ac9920686f2fbf6f701c33c"
    sha256                               arm64_sonoma:  "162fc180bacd0ee2e086581e180bd70f20b8ffec1ac9920686f2fbf6f701c33c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c45c9b7d77e96afcaf137b0212c3c4d5126eca0c92a7424ef237e28bf273afe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb78df00995424853732f6c29e0fef8e0a11231206551282d312bddd64c753e"
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
