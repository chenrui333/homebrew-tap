class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.6.0.tgz"
  sha256 "51f1055532f594386879a2cf3e7f4a1dfe77aee2d470be5066aff069277142fb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "6fd0920a20707a358db7877c19001b7afa926551de643be12ec6f0616e688191"
    sha256                               arm64_sequoia: "6fd0920a20707a358db7877c19001b7afa926551de643be12ec6f0616e688191"
    sha256                               arm64_sonoma:  "6fd0920a20707a358db7877c19001b7afa926551de643be12ec6f0616e688191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fce9875b6e41364c5d950a1154695f14a4394cdcc27e4649cf9024d4722b253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f403697f3a9ca145fdcce6198e2374d90655345b7e4e685160bd80e61326ea2"
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
