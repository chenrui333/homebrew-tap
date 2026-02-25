class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.15.3.tgz"
  sha256 "176be1ce0552fb1538104d2919e5fc955251d9685ebcbf641e8f4e2924670038"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "7f81e8329ab01ee06c8887a24af97d3204d5e97c3e46e975f747cf9c94f7d633"
    sha256                               arm64_sequoia: "7f81e8329ab01ee06c8887a24af97d3204d5e97c3e46e975f747cf9c94f7d633"
    sha256                               arm64_sonoma:  "7f81e8329ab01ee06c8887a24af97d3204d5e97c3e46e975f747cf9c94f7d633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ead795fcc2ad232990e05890d20b6669f99dd4f761ac3abe4ef5040f9390af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2459e79ab1beab6bafb19cda4a7498c6d5b4fba426218ef6904e3438a9f92afd"
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
