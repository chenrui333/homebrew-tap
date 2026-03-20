class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.16.3.tgz"
  sha256 "d348b9d1cb9ba7f61eeb5c68b07a752ef755f6061263608b6fac37e6255837b1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b163138f45eb7b269e373bedb9e203011da8c9d9ff81f6b51ec21dc23e9ac017"
    sha256                               arm64_sequoia: "b163138f45eb7b269e373bedb9e203011da8c9d9ff81f6b51ec21dc23e9ac017"
    sha256                               arm64_sonoma:  "b163138f45eb7b269e373bedb9e203011da8c9d9ff81f6b51ec21dc23e9ac017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a236ca62ec97890f9b5195d933dec1f05a0750dbb6bdba606a29f1edfc71904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d38b795156ba93a35127f0274805ef9e660762047c94001014ab1fa768e8c303"
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
