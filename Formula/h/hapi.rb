class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.11.1.tgz"
  sha256 "b2d2cd366700586a1640f972e941ca75eab1f1bf1c233574e4ec318b399f3581"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1a57d109b6dfc369f2067d16898199738640ddf4b5c99c8a0bdeea13614b9c7f"
    sha256                               arm64_sequoia: "1a57d109b6dfc369f2067d16898199738640ddf4b5c99c8a0bdeea13614b9c7f"
    sha256                               arm64_sonoma:  "1a57d109b6dfc369f2067d16898199738640ddf4b5c99c8a0bdeea13614b9c7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbc5140650f6f11faaaf45c8157176a7ad728638c8f86df29c4309490cf5e893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c528a73cbdff0b3589f7ef9ac27efbfeecba1f96fa19ae8099bace4af82ddfdc"
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
