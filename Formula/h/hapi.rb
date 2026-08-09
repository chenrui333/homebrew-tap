class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.27.2.tgz"
  sha256 "e9174cc9a40f68ab5e367b1a78c419714f092c597814f64ecc4fb42f91c8a519"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "dee364d990c27680701045dbd69c9c6f0bce74733a791737cdfb3476abc1eaa2"
    sha256                               arm64_sequoia: "dee364d990c27680701045dbd69c9c6f0bce74733a791737cdfb3476abc1eaa2"
    sha256                               arm64_sonoma:  "dee364d990c27680701045dbd69c9c6f0bce74733a791737cdfb3476abc1eaa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e4f55714b1e42422db9b7201f4fa15228b5c4ce0b7eba9638f7dfc410ee5e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e029778a45375e09f4bd440ee065831cdd33b596d0b14fc6b6a0d31b5e963ff"
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
