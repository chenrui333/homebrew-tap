class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.23.1.tgz"
  sha256 "344421e42c68d6011c325e344e915e95b973ca111cf96671a4e1ddff5b65617f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "79a47d4778bb2519a778a367804318f62cac6956d9e53f13c474ce2b266d4db9"
    sha256                               arm64_sequoia: "79a47d4778bb2519a778a367804318f62cac6956d9e53f13c474ce2b266d4db9"
    sha256                               arm64_sonoma:  "79a47d4778bb2519a778a367804318f62cac6956d9e53f13c474ce2b266d4db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5793277731e7ff6909724dbd4ce0d3363fa618e8c6a82f71d316a8b095a23d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1344eeb1bcff487997dd1ad6d59d9de5860b34b663edf0f6fc3487afa797c3b9"
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
